import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../data/models/photo.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryView extends StatelessWidget {
  final List<Photo> photos;
  const GalleryView({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: photos.length,
      itemBuilder: (c, i) {
        final p = photos[i];
        return GestureDetector(
          onTap: () => _openGallery(context, i),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(imageUrl: p.url, fit: BoxFit.cover),
                ),
                if (p.captionVi != null && p.captionVi!.isNotEmpty)
                  Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                      child: Text(p.captionVi!,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openGallery(BuildContext context, int startIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (ctx) {
        return GestureDetector(
          onVerticalDragEnd: (_) => Navigator.pop(ctx),
          child: Dismissible(
            key: const Key('gallery'),
            direction: DismissDirection.vertical,
            onDismissed: (_) => Navigator.pop(ctx),
            child: PhotoViewGallery.builder(
              itemCount: photos.length,
              pageController: PageController(initialPage: startIndex),
              builder: (_, i) => PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(photos[i].url),
                heroAttributes: PhotoViewHeroAttributes(tag: photos[i].id),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 2.5,
              ),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }
}
