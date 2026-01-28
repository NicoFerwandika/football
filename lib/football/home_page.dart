import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'news_page.dart';
import 'match_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import 'other_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  Future<String> _welcome() async {
    final prefs = await SharedPreferences.getInstance();
    final email = (prefs.getString("user_email") ?? "").toLowerCase();

    // ✅ TANPA ubah API/database login: admin ditentukan dari email
    final isAdmin = email.contains("admin");
    return isAdmin ? "Selamat datang Admin" : "Selamat datang User";
  }

  @override
  Widget build(BuildContext context) {
    final pageWidgets = [
      const NewsPage(),
      const MatchPage(),
      ProfilePage(),
      const AboutPage(),
      const OtherPage(),
    ];

    return Scaffold(
      appBar: index == 2
          ? null
          : AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.sports_soccer),
            SizedBox(width: 8),
            Text("FootballZone"),
          ],
        ),
        centerTitle: true,
      ),

      // ✅ Banner welcome hanya di Dashboard (menu pertama)
      body: Column(
        children: [
          if (index == 0)
            FutureBuilder<String>(
              future: _welcome(),
              builder: (context, snap) {
                final text = snap.data ?? "";
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ),
                );
              },
            ),

          Expanded(child: pageWidgets[index]),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Berita"),
          BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: "Jadwal"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Tentang"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "Lainnya"),
        ],
      ),
    );
  }
}
