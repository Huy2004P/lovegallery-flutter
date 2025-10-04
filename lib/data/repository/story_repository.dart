import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story.dart';
import 'remote_json_source.dart';
import 'local_cache.dart';

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  // Thay URL này bằng đường dẫn JSON thật của bạn
  const jsonUrl = 'https://github.com/Huy2004P/my-couple-story-website/tree/main/data/stories.json';
  return StoryRepository(RemoteJsonSource(jsonUrl), LocalCache());
});

class StoryRepository {
  final RemoteJsonSource remote;
  final LocalCache cache;
  StoryRepository(this.remote, this.cache);

  Future<List<Story>> loadStories({bool forceRefresh=false}) async {
    String? raw = await cache.readStoriesJson();
    if (forceRefresh || raw == null) {
      raw = await remote.fetchRaw();
      await cache.saveStoriesJson(raw);
    }
    return Story.listFromJson(raw);
  }

  Future<void> toggleFavorite(String id) => cache.toggleFavorite(id);
  Future<bool> isFavorite(String id) => cache.isFavorite(id);
  Future<Set<String>> favorites() => cache.readFavorites();
}
