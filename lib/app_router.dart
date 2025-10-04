import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/home/home_page.dart';
import 'features/story_detail/story_detail_page.dart';
import 'features/favorites/favorites_page.dart';
import 'features/settings/settings_page.dart';
import 'data/models/story.dart';


final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (c, s) => const NoTransitionPage(child: HomePage()),
    ),
    GoRoute(
      name: 'storyDetail',
      path: '/story/:id',
      builder: (context, state) {
        final story = state.extra as Story;
        return StoryDetailPage(story: story);
      },
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (c, s) => const FavoritesPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (c, s) => const SettingsPage(),
    ),
  ],
);
