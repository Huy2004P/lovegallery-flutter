import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../data/repository/story_repository.dart';
import '../../features//widgets/falling_overlay.dart';
import 'package:ourstories/features/home/story_card.dart';
import '../../services/bgm_service.dart';


final fallingEnabledProvider = StateProvider<bool>((ref) => true);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // ✅ Phát nhạc khi vào trang chủ
    BgmService.instance.initAndPlay();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(storyRepositoryProvider);
    final fallingOn = ref.watch(fallingEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Huy & Trí — Our Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.goNamed('favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.goNamed('settings'),
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: repo.loadStories(),
            builder: (c, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Lỗi tải dữ liệu: ${snap.error}'));
              }
              final stories = snap.data!;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: stories.length,
                  itemBuilder: (c, i) => StoryCard(story: stories[i]),
                ),
              );
            },
          ),
          Positioned.fill(
            child: FallingOverlay(
              enabled: fallingOn,
              asset: 'assets/particles/sakura.json',
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: GestureDetector(
              onLongPress: () => ref.read(fallingEnabledProvider.notifier).state = !fallingOn,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: fallingOn ? 1 : 0.3,
                child: FloatingActionButton(
                  onPressed: () =>
                  ref.read(fallingEnabledProvider.notifier).state =
                  !ref.read(fallingEnabledProvider),
                  child: Icon(fallingOn ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
