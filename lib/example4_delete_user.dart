import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String base = 'https://jsonplaceholder.typicode.com';

class Example4DeleteUserPage extends StatefulWidget {
  const Example4DeleteUserPage({super.key});

  @override
  State<Example4DeleteUserPage> createState() => _Example4DeleteUserPageState();
}

class _Example4DeleteUserPageState extends State<Example4DeleteUserPage> {
  final _idController = TextEditingController(text: '1');
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> confirmDelete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ยืนยันการลบ?'),
        content: Text('คุณต้องการลบผู้ใช้ ID $id ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    setState(() {
      _loading = true;
    });

    try {
      final res = await http.delete(Uri.parse('$base/users/$id'));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res.statusCode == 200
                ? 'ลบสำเร็จ (HTTP 200)'
                : 'ลบไม่สำเร็จ (${res.statusCode})',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
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
      appBar: AppBar(title: const Text('ตัวอย่าง 4: DELETE User')),
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
                helperText: 'กรอก ID แล้วกดลบ เช่น 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading
                  ? null
                  : () {
                      final id = int.tryParse(_idController.text.trim());
                      if (id == null || id <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('กรุณากรอก ID เป็นตัวเลขที่ถูกต้อง')),
                        );
                        return;
                      }
                      confirmDelete(id);
                    },
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete),
              label: Text(_loading ? 'กำลังลบ...' : 'ลบผู้ใช้'),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'ขั้นตอน: กดปุ่มลบ → แสดง Dialog → กดยืนยัน → เรียก DELETE → แจ้งผลด้วย SnackBar',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
