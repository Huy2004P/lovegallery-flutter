import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FallingOverlay extends StatelessWidget {
  final bool enabled;
  final String asset; // assets/particles/sakura.json hoặc snow.json
  const FallingOverlay({super.key, required this.enabled, required this.asset});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox.shrink();
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Opacity(
          opacity: 0.85,
          child: Lottie.asset(asset, repeat: true, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
