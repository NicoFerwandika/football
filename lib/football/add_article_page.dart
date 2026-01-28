import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({super.key});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final title = TextEditingController();
  final content = TextEditingController();
  final image = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    image.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Artikel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: content,
              decoration: const InputDecoration(labelText: 'Konten'),
            ),
            TextField(
              controller: image,
              decoration: const InputDecoration(labelText: 'URL Gambar'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final ok = await ApiService.addArticle(
                    title: title.text.trim(),
                    content: content.text.trim(),
                    image: image.text.trim(),
                  );

                  if (!mounted) return;

                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Artikel berhasil ditambahkan")),
                    );
                    Navigator.pop(context, true); // balik + refresh
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Gagal"),
                        content: const Text("Gagal menambahkan artikel"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
