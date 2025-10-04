import 'dart:convert';
import 'package:http/http.dart' as http;

/// Trỏ tới file JSON của bạn trên GitHub Pages
class RemoteJsonSource {
  final Uri jsonUrl;
  RemoteJsonSource(String url): jsonUrl = Uri.parse(url);

  Future<String> fetchRaw() async {
    final res = await http.get(jsonUrl);
    if (res.statusCode != 200) {
      throw Exception('Fetch failed: ${res.statusCode}');
    }
    return utf8.decode(res.bodyBytes); // giữ Unicode
  }
}
