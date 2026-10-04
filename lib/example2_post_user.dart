import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String base = 'https://jsonplaceholder.typicode.com';

Future<Map<String, dynamic>> addUser(String name, String email) async {
  final res = await http.post(
    Uri.parse('$base/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': name, 'email': email}),
  );

  if (res.statusCode == 201) {
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  throw Exception('สร้างไม่สำเร็จ (${res.statusCode})');
}

class Example2PostUserPage extends StatefulWidget {
  const Example2PostUserPage({super.key});

  @override
  State<Example2PostUserPage> createState() => _Example2PostUserPageState();
}

class _Example2PostUserPageState extends State<Example2PostUserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      setState(() {
        _error = 'กรุณากรอกชื่อและอีเมลให้ครบ';
        _result = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final user = await addUser(name, email);
      if (!mounted) return;
      setState(() {
        _result = user;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ตัวอย่าง 2: POST User')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'อีเมล',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _submit,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_loading ? 'กำลังส่ง...' : 'สร้างผู้ใช้'),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
            if (_result != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'สร้างสำเร็จ (HTTP 201)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('ID: ${_result!['id']}'),
                      Text('ชื่อ: ${_result!['name']}'),
                      Text('อีเมล: ${_result!['email']}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
