import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ Emulator Android Studio
  static const String baseUrl = "http://10.0.2.2/football_api";
  static const Duration _timeout = Duration(seconds: 8);

  // =================== LOGIN ===================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http
        .post(
      Uri.parse("$baseUrl/login.php"),
      body: {"email": email, "password": password},
    )
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception("HTTP ${res.statusCode}");
    final decoded = jsonDecode(res.body);
    return Map<String, dynamic>.from(decoded as Map);
  }

  // =================== REGISTER ===================
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final res = await http
        .post(
      Uri.parse("$baseUrl/register.php"),
      body: {"email": email, "password": password},
    )
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception("HTTP ${res.statusCode}");
    final decoded = jsonDecode(res.body);
    return Map<String, dynamic>.from(decoded as Map);
  }

  // =================== ARTICLES ===================
  static Future<List> getArticles() async {
    final res = await http
        .get(Uri.parse("$baseUrl/article_list.php"))
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception("HTTP ${res.statusCode}");
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return (map["data"] as List?) ?? [];
  }

  static Future<bool> addArticle({
    required String title,
    required String content,
    required String image,
  }) async {
    final res = await http
        .post(
      Uri.parse("$baseUrl/article_add.php"),
      body: {"title": title, "content": content, "image": image},
    )
        .timeout(_timeout);

    if (res.statusCode != 200) return false;
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return map["status"] == true;
  }

  static Future<bool> updateArticle({
    required String id,
    required String title,
    required String content,
    required String image,
  }) async {
    final res = await http
        .post(
      Uri.parse("$baseUrl/article_update.php"),
      body: {"id": id, "title": title, "content": content, "image": image},
    )
        .timeout(_timeout);

    if (res.statusCode != 200) return false;
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return map["status"] == true;
  }

  static Future<bool> deleteArticle(String id) async {
    final res = await http
        .post(Uri.parse("$baseUrl/article_delete.php"), body: {"id": id})
        .timeout(_timeout);

    if (res.statusCode != 200) return false;
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return map["status"] == true;
  }

  // =================== MATCHES ===================
  static Future<List> getMatches() async {
    final res = await http
        .get(Uri.parse("$baseUrl/matches.php"))
        .timeout(_timeout);

    if (res.statusCode != 200) throw Exception("HTTP ${res.statusCode}");
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return (map["data"] as List?) ?? [];
  }
  static Future<bool> addMatch({
    required String homeTeam,
    required String awayTeam,
    required String matchDate,
  }) async {
    final res = await http
        .post(
      Uri.parse("$baseUrl/matches_add.php"),
      body: {
        "home_team": homeTeam,
        "away_team": awayTeam,
        "match_date": matchDate,
      },
    )
        .timeout(_timeout);

    if (res.statusCode != 200) return false;
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return map["status"] == true;
  }

  static Future<bool> updateMatch({
    required String id,
    required String homeTeam,
    required String awayTeam,
    required String matchDate,
  }) async {
    final res = await http
        .post(
      Uri.parse("$baseUrl/matches_update.php"),
      body: {
        "id": id,
        "home_team": homeTeam,
        "away_team": awayTeam,
        "match_date": matchDate,
      },
    )
        .timeout(_timeout);

    if (res.statusCode != 200) return false;
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return map["status"] == true;
  }

  static Future<bool> deleteMatch(String id) async {
    final res = await http
        .post(
      Uri.parse("$baseUrl/matches_delete.php"),
      body: {"id": id},
    )
        .timeout(_timeout);

    if (res.statusCode != 200) return false;
    final decoded = jsonDecode(res.body);
    final map = Map<String, dynamic>.from(decoded as Map);
    return map["status"] == true;
  }

}

