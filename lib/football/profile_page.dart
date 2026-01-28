import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/app_ui.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  Future<Map<String, String>> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "id": prefs.getString("user_id") ?? "-",
      "email": prefs.getString("user_email") ?? "Admin",
    };
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
    return FutureBuilder<Map<String, String>>(
      future: _getUser(),
      builder: (context, snap) {
        final data = snap.data ?? {"id": "-", "email": "Admin"};

        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: const [
                    Text("Profil", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  ],
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: AppUI.cardBox(),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        height: 76,
                        width: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/profile.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["email"] ?? "Admin",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text("User ID: ${data["id"]}", style: TextStyle(color: Colors.grey.shade700)),
                            const SizedBox(height: 10),
                            AppUI.pill("Admin FootballZone"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  decoration: AppUI.cardBox(),
                  child: Column(
                    children: [
                      ListTile(
                        leading: AppUI.iconBox(Icons.person),
                        title: const Text("Edit Profil (dummy)", style: TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: const Text("Untuk checklist UI"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Message"),
                              content: const Text("Fitur edit profil masih dummy ✅"),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: AppUI.iconBox(Icons.security),
                        title: const Text("Keamanan (dummy)", style: TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: const Text("Contoh menu"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Menu keamanan (dummy)")),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
