import 'package:flutter/material.dart';

import 'example1_get_users.dart';
import 'example2_post_user.dart';
import 'example3_put_user.dart';
import 'example4_delete_user.dart';
import 'example5_search_posts.dart';

void main() {
  runApp(const WorkedExamplesApp());
}

class WorkedExamplesApp extends StatelessWidget {
  const WorkedExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter HTTP Worked Examples',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final examples = <_ExampleItem>[
      const _ExampleItem(
        number: 1,
        title: 'GET — รายการผู้ใช้',
        subtitle: 'ดึงข้อมูลทั้งหมดจาก /users',
        page: Example1GetUsersPage(),
        icon: Icons.download,
      ),
      const _ExampleItem(
        number: 2,
        title: 'POST — สร้างผู้ใช้',
        subtitle: 'ส่งชื่อและอีเมลไปสร้างข้อมูลใหม่',
        page: Example2PostUserPage(),
        icon: Icons.person_add,
      ),
      const _ExampleItem(
        number: 3,
        title: 'PUT — แก้ไขข้อมูล',
        subtitle: 'แก้ไขชื่อผู้ใช้ด้วย /users/{id}',
        page: Example3PutUserPage(),
        icon: Icons.edit,
      ),
      const _ExampleItem(
        number: 4,
        title: 'DELETE — ลบพร้อมยืนยัน',
        subtitle: 'ยืนยันใน Dialog ก่อนเรียก DELETE',
        page: Example4DeleteUserPage(),
        icon: Icons.delete,
      ),
      const _ExampleItem(
        number: 5,
        title: 'ค้นหา — Query Parameters',
        subtitle: 'ค้นหาโพสต์ด้วย q และ _limit',
        page: Example5SearchPostsPage(),
        icon: Icons.search,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Worked Examples'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ตัวอย่างเสริม 5 ตัวอย่าง',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'การเรียก API ในสถานการณ์จริงด้วย Flutter และ HTTP Methods',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...examples.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: CircleAvatar(
                  child: Icon(item.icon),
                ),
                title: Text(
                  '${item.number}. ${item.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item.subtitle),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _open(context, item.page),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleItem {
  final int number;
  final String title;
  final String subtitle;
  final Widget page;
  final IconData icon;

  const _ExampleItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.page,
    required this.icon,
  });
}
