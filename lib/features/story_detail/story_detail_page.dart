import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 👈 thêm dòng này
import '../../data/models/story.dart';

class StoryDetailPage extends StatelessWidget {
  final Story story;
  const StoryDetailPage({super.key, required this.story});

  Uint8List? _decodeBase64Image(String s) {
    try {
      if (s.startsWith('data:image/') && s.contains(';base64,')) {
        final idx = s.indexOf(';base64,');
        return base64Decode(s.substring(idx + ';base64,'.length));
      }
    } catch (_) {}
    return null;
  }

  Widget _buildImage(String src) {
    final mem = _decodeBase64Image(src);
    if (mem != null) {
      return Image.memory(
        mem,
        fit: BoxFit.cover,
        width: double.infinity,
        gaplessPlayback: true,
      );
    }
    return CachedNetworkImage(
      imageUrl: src,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (_, __) => const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, __, ___) => const SizedBox(
        height: 200,
        child: Center(child: Icon(Icons.broken_image_outlined)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nội dung fallback: ưu tiên noteVi -> noteEn -> thông báo trống
    final content = (story.noteVi != null && story.noteVi!.trim().isNotEmpty)
        ? story.noteVi!
        : ((story.noteEn != null && story.noteEn!.trim().isNotEmpty)
        ? story.noteEn!
        : '(Chưa có nội dung chi tiết cho câu chuyện này)');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            // 👇 Nút back rõ ràng
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
              tooltip: 'Quay lại',
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(story.coverUrl),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                story.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (story.contentVi != null && story.contentVi!.isNotEmpty)
                    Text(
                      story.contentVi!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  else
                    const Text(
                      '(Chưa có nội dung chi tiết cho câu chuyện này)',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
