import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditArticlePage extends StatefulWidget {
  final Map article;
  const EditArticlePage({super.key, required this.article});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  late TextEditingController title;
  late TextEditingController content;
  late TextEditingController image;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.article['title']);
    content = TextEditingController(text: widget.article['content']);
    image = TextEditingController(text: widget.article['image']);
  }

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
      appBar: AppBar(title: const Text('Edit Artikel')),
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
                  final ok = await ApiService.updateArticle(
                    id: widget.article['id'].toString(),
                    title: title.text.trim(),
                    content: content.text.trim(),
                    image: image.text.trim(),
                  );

                  if (!mounted) return;

                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Artikel berhasil diupdate")),
                    );
                    Navigator.pop(context, true);
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Gagal"),
                        content: const Text("Gagal update artikel"),
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
                child: const Text('Update'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
