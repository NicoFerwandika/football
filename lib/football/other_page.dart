import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  void _showMessage(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Message"),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Yakin ingin logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Logout")),
        ],
      ),
    );

    if (ok != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF1FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.more_horiz, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Menu Lainnya",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Pengaturan & menu tambahan",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // List menu modern
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            children: [
              _tile(
                icon: Icons.refresh,
                title: "Refresh",
                subtitle: "Contoh SnackBar",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Refresh berhasil ✅")),
                  );
                },
              ),
              const Divider(height: 1),
              _tile(
                icon: Icons.message,
                title: "Tampilkan Message",
                subtitle: "Contoh AlertDialog",
                onTap: () => _showMessage(context, "Halo! Ini message dari Menu Lainnya ✅"),
              ),
              const Divider(height: 1),
              _tile(
                icon: Icons.help_outline,
                title: "Bantuan",
                subtitle: "Panduan singkat penggunaan",
                onTap: () => _showMessage(
                  context,
                  "Cara pakai:\n- Login/Register\n- Kelola Artikel (CRUD)\n- Kelola Jadwal (CRUD)\n- Logout di menu Lainnya",
                ),
              ),
              const Divider(height: 1),
              _tile(
                icon: Icons.logout,
                title: "Logout",
                subtitle: "Keluar dari akun",
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Bonus kecil biar keren
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Nico Ferwandika Nim : 2023230055",
                  style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
