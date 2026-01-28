import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../ui/app_ui.dart';
import 'add_article_page.dart';
import 'edit_article_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool loading = true;
  List articles = [];
  String error = "";

  String getFootballImage(String title) {
    final t = title.toLowerCase();

    if (t.contains("messi")) {
      return "https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=1200&q=80";
    }
    if (t.contains("ronaldo")) {
      return "https://images.unsplash.com/photo-1522778526097-ce0a22ceb253?auto=format&fit=crop&w=1200&q=80";
    }
    if (t.contains("mbappe")) {
      return "https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a?auto=format&fit=crop&w=1200&q=80";
    }

    return "https://images.unsplash.com/photo-1518091043644-c1d4457512c6?auto=format&fit=crop&w=1200&q=80";
  }

  Future<void> load() async {
    setState(() { loading = true; error = ""; });
    try {
      final data = await ApiService.getArticles();
      setState(() { articles = data; loading = false; });
    } catch (e) {
      setState(() { error = "Gagal load artikel: $e"; loading = false; });
    }
  }

  Future<void> _deleteConfirm(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Artikel"),
        content: const Text("Yakin ingin menghapus artikel ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (ok != true) return;

    final success = await ApiService.deleteArticle(id);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Artikel berhasil dihapus")));
      load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus artikel")));
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddArticlePage()));
          if (result == true) load();
        },
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : RefreshIndicator(
        onRefresh: load,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: articles.length,
          itemBuilder: (context, i) {
            final a = articles[i];
            final id = a["id"].toString();
            final title = (a["title"] ?? "").toString();
            final content = (a["content"] ?? "").toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: AppUI.cardBox(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.network(
                      getFootballImage(title),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Icon(Icons.sports_soccer, size: 70),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            AppUI.pill("News"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => EditArticlePage(article: a)),
                                );
                                if (result == true) load();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteConfirm(id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
