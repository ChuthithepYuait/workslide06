import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String base = 'https://jsonplaceholder.typicode.com';

Future<List<dynamic>> search(String q, {int limit = 5}) async {
  final uri = Uri.parse('$base/posts').replace(
    queryParameters: {
      'q': q,
      '_limit': '$limit',
    },
  );

  final res = await http.get(uri).timeout(const Duration(seconds: 10));

  if (res.statusCode == 200) {
    return jsonDecode(res.body) as List<dynamic>;
  }

  throw Exception('ค้นหาไม่สำเร็จ (${res.statusCode})');
}

class Example5SearchPostsPage extends StatefulWidget {
  const Example5SearchPostsPage({super.key});

  @override
  State<Example5SearchPostsPage> createState() => _Example5SearchPostsPageState();
}

class _Example5SearchPostsPageState extends State<Example5SearchPostsPage> {
  final _queryController = TextEditingController(text: 'flutter');
  int _limit = 5;
  bool _loading = false;
  List<dynamic> _results = [];
  String? _error;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final q = _queryController.text.trim();

    if (q.isEmpty) {
      setState(() {
        _error = 'กรุณากรอกคำค้น';
        _results = [];
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await search(q, limit: _limit);
      if (!mounted) return;
      setState(() {
        _results = data;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _results = [];
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
      appBar: AppBar(title: const Text('ตัวอย่าง 5: Search Posts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _queryController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    labelText: 'คำค้น',
                    hintText: 'เช่น flutter',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: _loading ? null : _search,
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('จำนวนผลลัพธ์: '),
                    DropdownButton<int>(
                      value: _limit,
                      items: const [
                        DropdownMenuItem(value: 5, child: Text('5')),
                        DropdownMenuItem(value: 10, child: Text('10')),
                        DropdownMenuItem(value: 20, child: Text('20')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _limit = value);
                        }
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _loading ? null : _search,
                      child: const Text('ค้นหา'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: LinearProgressIndicator(),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: _results.isEmpty && !_loading && _error == null
                ? const Center(child: Text('ยังไม่มีผลลัพธ์'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final post = _results[index] as Map<String, dynamic>;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${post['id']}. ${post['title']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(post['body'].toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
