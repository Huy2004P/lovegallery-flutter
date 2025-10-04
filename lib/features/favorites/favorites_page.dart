import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/story_repository.dart';
import '../../data/models/story.dart';
import '../home/story_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(storyRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Yêu thích')),
      body: FutureBuilder(
        future: Future.wait([repo.loadStories(), repo.favorites()]),
        builder: (c, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final stories = snap.data![0] as List<Story>;
          final favs = snap.data![1] as Set<String>;
          final list = stories.where((s) => favs.contains(s.id)).toList();
          if (list.isEmpty) {
            return const Center(child: Text('Chưa có câu chuyện nào được yêu thích'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: StoryCard(story: list[i]),
            ),
          );
        },
      ),
    );
  }
}
