import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final pass2C = TextEditingController();
  bool loading = false;

  bool _isValidGmail(String email) {
    final e = email.trim().toLowerCase();
    // ✅ hanya boleh gmail.com
    return RegExp(r'^[\w\.\-]+@gmail\.com$').hasMatch(e);
  }

  Future<void> _register() async {
    final email = emailC.text.trim();
    final pass = passC.text.trim();
    final pass2 = pass2C.text.trim();

    // validasi kosong
    if (email.isEmpty || pass.isEmpty || pass2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    // ✅ validasi email harus @gmail.com
    if (!_isValidGmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email harus valid dan menggunakan @gmail.com")),
      );
      return;
    }

    // validasi password minimal
    if (pass.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 4 karakter")),
      );
      return;
    }

    // validasi konfirmasi password
    if (pass != pass2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi password tidak sama")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final res = await ApiService.register(email: email, password: pass);
      final ok = res["status"] == true;
      final msg = (res["message"] ?? "").toString();

      setState(() => loading = false);

      if (!ok) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Register Gagal"),
            content: Text(msg.isNotEmpty ? msg : "Register gagal"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
        return;
      }

      // sukses
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Register Berhasil"),
          content: const Text("Akun berhasil dibuat. Silakan login."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.pop(context); // balik ke LoginPage
    } catch (e) {
      setState(() => loading = false);
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Gagal koneksi/timeout: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    pass2C.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
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
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Buat Akun",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  "Email wajib @gmail.com",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "contoh@gmail.com",
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "minimal 4 karakter",
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: pass2C,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Konfirmasi Password",
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _register,
                    child: loading
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
