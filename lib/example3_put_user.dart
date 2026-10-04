import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String base = 'https://jsonplaceholder.typicode.com';

Future<bool> updateUser(int id, String name) async {
  final res = await http.put(
    Uri.parse('$base/users/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': id, 'name': name}),
  );

  if (res.statusCode == 200) return true;

  throw Exception('แก้ไขไม่สำเร็จ (${res.statusCode})');
}

class Example3PutUserPage extends StatefulWidget {
  const Example3PutUserPage({super.key});

  @override
  State<Example3PutUserPage> createState() => _Example3PutUserPageState();
}

class _Example3PutUserPageState extends State<Example3PutUserPage> {
  final _idController = TextEditingController(text: '1');
  final _nameController = TextEditingController(text: 'Leanne Graham Updated');
  bool _loading = false;
  String? _message;
  bool _success = false;

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    final id = int.tryParse(_idController.text.trim());
    final name = _nameController.text.trim();

    if (id == null || id <= 0 || name.isEmpty) {
      setState(() {
        _success = false;
        _message = 'กรุณาระบุ ID เป็นตัวเลข และกรอกชื่อ';
      });
      return;
    }

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final result = await updateUser(id, name);
      if (!mounted) return;
      setState(() {
        _success = result;
        _message = result ? 'แก้ไขสำเร็จ (HTTP 200)' : 'แก้ไขไม่สำเร็จ';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _success = false;
        _message = e.toString();
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
      appBar: AppBar(title: const Text('ตัวอย่าง 3: PUT User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'User ID',
                helperText: 'ตัวอย่าง: 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อใหม่',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _update,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_loading ? 'กำลังแก้ไข...' : 'แก้ไขข้อมูล'),
            ),
            const SizedBox(height: 16),
            if (_message != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _message!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _success
                          ? Colors.green.shade700
                          : Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
