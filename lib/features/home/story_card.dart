import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/story.dart';
// thêm import:
import 'dart:convert';
import 'dart:typed_data';

class StoryCard extends StatelessWidget {
  final Story story;
  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = 20.0;

    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: () => context.pushNamed('storyDetail', pathParameters: {'id': story.id}, extra: story),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              const Color(0xFF8EC5FC).withOpacity(0.3),
              const Color(0xFFE0C3FC).withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                      child: _CoverImage(src: story.coverUrl),
                  ),
                  if (story.createdAt != null)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: _GlassChip(
                        text:
                        '${story.createdAt!.day.toString().padLeft(2, '0')}/${story.createdAt!.month.toString().padLeft(2, '0')}/${story.createdAt!.year}',
                      ),
                    ),
                ],
              ),
              Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.3),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if ((story.subtitle ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        story.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final String text;
  const _GlassChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ... bên trong file, tạo widget hiển thị cover theo nguồn:
class _CoverImage extends StatelessWidget {
  final String src;
  const _CoverImage({required this.src});

  bool _isDataUrl(String s) => s.startsWith('data:image/') && s.contains(';base64,');
  bool _isLikelyBase64(String s) =>
      !(s.startsWith('http://') || s.startsWith('https://')) &&
          s.length > 100 &&
          RegExp(r'^[A-Za-z0-9+/=\s]+$').hasMatch(s);

  Uint8List? _decode(String s) {
    try {
      if (_isDataUrl(s)) {
        final idx = s.indexOf(';base64,');
        return base64Decode(s.substring(idx + 8));
      }
      if (_isLikelyBase64(s)) return base64Decode(s);
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final mem = _decode(src);
    if (mem != null) {
      return Image.memory(mem, fit: BoxFit.cover, filterQuality: FilterQuality.low);
    }
    return CachedNetworkImage(
      imageUrl: src,
      fit: BoxFit.cover,
      memCacheWidth: 600,
      filterQuality: FilterQuality.low,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (_, __) => const Center(
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined)),
    );
  }
}
