import 'package:shared_preferences/shared_preferences.dart';

class LocalCache {
  static const _kStoriesJson = 'stories_json';
  static const _kFavorites = 'favorite_story_ids';

  Future<void> saveStoriesJson(String json) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kStoriesJson, json);
  }

  Future<String?> readStoriesJson() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kStoriesJson);
  }

  Future<Set<String>> readFavorites() async {
    final p = await SharedPreferences.getInstance();
    return p.getStringList(_kFavorites)?.toSet() ?? <String>{};
  }

  Future<void> toggleFavorite(String id) async {
    final p = await SharedPreferences.getInstance();
    final set = await readFavorites();
    if (set.contains(id)) set.remove(id); else set.add(id);
    await p.setStringList(_kFavorites, set.toList());
  }

  Future<bool> isFavorite(String id) async {
    final set = await readFavorites();
    return set.contains(id);
  }
}
