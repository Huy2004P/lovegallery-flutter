import 'dart:convert';

/// ===== helpers cục bộ (không cần file khác) =====
T? _asT<T>(dynamic v) => (v is T) ? v : null;

String _readString(Map m, List<String> keys, {String fallback = ''}) {
  for (final k in keys) {
    final v = m[k];
    if (v is String && v.trim().isNotEmpty) return v;
  }
  return fallback;
}

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  if (v is int) {
    final ms = v < 1000000000000 ? v * 1000 : v; // giây -> ms
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
/// =================================================

class Photo {
  final String id;
  final String url;           // có thể http/https hoặc base64
  final String? captionVi;
  final String? captionEn;
  final DateTime? takenAt;

  Photo({
    required this.id,
    required this.url,
    this.captionVi,
    this.captionEn,
    this.takenAt,
  });

  factory Photo.fromMap(Map<String, dynamic> m) {
    final rawUrl = _readString(m, ['url', 'image', 'src', 'photoUrl']);
    return Photo(
      id: _readString(m, ['id', 'photoId', 'key'], fallback: ''),
      url: _normalizeUrl(rawUrl),
      captionVi: _asT<String>(m['captionVi']) ?? _asT<String>(m['caption']),
      captionEn: _asT<String>(m['captionEn']),
      takenAt: _parseDate(m['takenAt'] ?? m['date']),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'url': url,
    'captionVi': captionVi,
    'captionEn': captionEn,
    'takenAt': takenAt?.toIso8601String(),
  };
}
