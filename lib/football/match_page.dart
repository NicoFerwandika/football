import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../ui/app_ui.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  bool loading = true;
  List matches = [];
  String error = "";

  Future<void> load() async {
    setState(() { loading = true; error = ""; });
    try {
      final data = await ApiService.getMatches();
      setState(() { matches = data; loading = false; });
    } catch (e) {
      setState(() { error = "Gagal load jadwal: $e"; loading = false; });
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> _addDialog() async {
    final home = TextEditingController();
    final away = TextEditingController();
    final date = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Jadwal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: home, decoration: const InputDecoration(labelText: "Home Team")),
            TextField(controller: away, decoration: const InputDecoration(labelText: "Away Team")),
            TextField(controller: date, decoration: const InputDecoration(labelText: "Tanggal (contoh: 2026-01-25)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Simpan")),
        ],
      ),
    );

    if (ok != true) return;

    final success = await ApiService.addMatch(
      homeTeam: home.text.trim(),
      awayTeam: away.text.trim(),
      matchDate: date.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Jadwal berhasil ditambah" : "Gagal tambah jadwal")),
    );
    if (success) load();
  }

  Future<void> _editDialog(Map m) async {
    final home = TextEditingController(text: (m["home_team"] ?? "").toString());
    final away = TextEditingController(text: (m["away_team"] ?? "").toString());
    final date = TextEditingController(text: (m["match_date"] ?? "").toString());

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Jadwal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: home, decoration: const InputDecoration(labelText: "Home Team")),
            TextField(controller: away, decoration: const InputDecoration(labelText: "Away Team")),
            TextField(controller: date, decoration: const InputDecoration(labelText: "Tanggal (contoh: 2026-01-25)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Update")),
        ],
      ),
    );

    if (ok != true) return;

    final success = await ApiService.updateMatch(
      id: m["id"].toString(),
      homeTeam: home.text.trim(),
      awayTeam: away.text.trim(),
      matchDate: date.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Jadwal berhasil diupdate" : "Gagal update jadwal")),
    );
    if (success) load();
  }

  Future<void> _deleteConfirm(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Jadwal"),
        content: const Text("Yakin ingin menghapus jadwal ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (ok != true) return;

    final success = await ApiService.deleteMatch(id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Jadwal berhasil dihapus" : "Gagal hapus jadwal")),
    );
    if (success) load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error.isNotEmpty) return Center(child: Text(error));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addDialog,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: matches.isEmpty
            ? ListView(children: const [SizedBox(height: 250), Center(child: Text("Belum ada jadwal."))])
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: matches.length,
          itemBuilder: (context, i) {
            final m = matches[i];
            final id = (m["id"] ?? "").toString();
            final home = (m["home_team"] ?? "Home").toString();
            final away = (m["away_team"] ?? "Away").toString();
            final date = (m["match_date"] ?? "-").toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: AppUI.cardBox(),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                leading: AppUI.iconBox(Icons.sports_soccer),
                title: Text("$home vs $away", style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(date, style: TextStyle(color: Colors.grey.shade700)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _editDialog(Map<String, dynamic>.from(m)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteConfirm(id),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
