import 'dart:convert';
import 'photo.dart';

/// ===== helpers cục bộ (không cần file khác) =====
T? _asT<T>(dynamic v) => (v is T) ? v : null;

String _readString(Map m, List<String> keys, {String fallback = ''}) {
  for (final k in keys) {
    final v = m[k];
    if (v is String && v.trim().isNotEmpty) return v;
  }
  return fallback;
}

List _readList(Map m, List<String> keys) {
  for (final k in keys) {
    final v = m[k];
    if (v is List) return v;
  }
  return const [];
}

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is int) {
    final ms = v < 1000000000000 ? v * 1000 : v;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return null;
    final d = DateTime.tryParse(s);
    if (d != null) return d;
    final m = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$').firstMatch(s);
    if (m != null) {
      return DateTime(int.parse(m.group(3)!), int.parse(m.group(2)!), int.parse(m.group(1)!));
    }
  }
  return null;
}

bool _isDataUrl(String s) => s.startsWith('data:image/') && s.contains(';base64,');
bool _isLikelyBase64(String s) =>
    !(s.startsWith('http://') || s.startsWith('https://')) &&
        s.length > 100 &&
        RegExp(r'^[A-Za-z0-9+/=\s]+$').hasMatch(s);

String _normalizeUrl(String url) {
  if (url.isEmpty) return url;
  final u = url.trim();
  if (_isDataUrl(u) || _isLikelyBase64(u)) return u; // để nguyên base64
  if (u.startsWith('http://') || u.startsWith('https://')) return u;
  const base = 'https://huy2004p.github.io/my-couple-story-website/';
  return '$base$u';
}

List<Map<String, dynamic>> _decodeStoryArray(String jsonStr) {
  final decoded = json.decode(jsonStr);
  if (decoded is List) return decoded.cast<Map<String, dynamic>>();
  if (decoded is Map) {
    final list = _readList(decoded, ['stories', 'items', 'data']);
    return list.cast<Map<String, dynamic>>();
  }
  return const [];
}
/// =================================================

class Story {
  final String id;
  final String title;
  final String? subtitle;
  final String coverUrl;      // có thể http/https hoặc base64
  final String? noteVi;
  final String? noteEn;
  final DateTime? createdAt;  // cho phép null
  final List<Photo> photos;
  final List<String> tags;

  // 👇 Thêm field này để đọc nội dung từ JSON key "story"
  final String? contentVi;

  Story({
    required this.id,
    required this.title,
    this.subtitle,
    required this.coverUrl,
    this.noteVi,
    this.noteEn,
    required this.createdAt,
    required this.photos,
    required this.tags,
    this.contentVi, // 👈 Thêm dòng này vào
  });

  factory Story.fromMap(Map<String, dynamic> m) {
    final rawCover = _readString(m, ['coverUrl', 'cover', 'image', 'thumbnail']);
    final rawPhotos = _readList(m, ['photos', 'images', 'gallery']).cast<Map<String, dynamic>>();

    return Story(
      id: _readString(m, ['id', 'slug', 'key'], fallback: ''),
      title: _readString(m, ['title', 'name'], fallback: ''),
      subtitle: _asT<String>(m['subtitle']),
      coverUrl: _normalizeUrl(rawCover),
      noteVi: _asT<String>(m['noteVi']) ?? _asT<String>(m['note']),
      noteEn: _asT<String>(m['noteEn']),
      createdAt: _parseDate(m['createdAt'] ?? m['created_at'] ?? m['date']),
      photos: rawPhotos.map((e) => Photo.fromMap(e)).toList(),
      tags: _readList(m, ['tags', 'labels']).map((e) => e.toString()).toList(),

      // 👇 parse nội dung câu chuyện
      contentVi: _asT<String>(m['story']),
    );
  }

  static List<Story> listFromJson(String jsonStr) {
    final list = _decodeStoryArray(jsonStr);
    return list.map((e) => Story.fromMap(e)).toList();
  }
}
