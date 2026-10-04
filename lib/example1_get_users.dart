import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String base = 'https://jsonplaceholder.typicode.com';

Future<List<dynamic>> getUsers() async {
  final res = await http
      .get(Uri.parse('$base/users'))
      .timeout(const Duration(seconds: 10));

  if (res.statusCode == 200) {
    return jsonDecode(res.body) as List<dynamic>;
  }

  throw Exception('โหลดผู้ใช้ไม่สำเร็จ (${res.statusCode})');
}

class Example1GetUsersPage extends StatefulWidget {
  const Example1GetUsersPage({super.key});

  @override
  State<Example1GetUsersPage> createState() => _Example1GetUsersPageState();
}

class _Example1GetUsersPageState extends State<Example1GetUsersPage> {
  late Future<List<dynamic>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = getUsers();
  }

  void _reload() {
    setState(() {
      _futureUsers = getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตัวอย่าง 1: GET Users'),
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
            tooltip: 'โหลดใหม่',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('ลองอีกครั้ง'),
                    ),
                  ],
                ),
              ),
            );
          }

          final users = snapshot.data ?? [];

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index] as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${user['id']}'),
                  ),
                  title: Text(user['name'].toString()),
                  subtitle: Text(user['email'].toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
