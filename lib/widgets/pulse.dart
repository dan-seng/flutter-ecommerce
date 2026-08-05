import 'package:flutter/material.dart';

/// Animated shimmer used while the catalog loads.
class Pulse extends StatefulWidget {
  const Pulse({super.key, required this.child});

  final Widget child;

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: widget.child,
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, this.height, this.radius = 14});

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE9E2D6),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class SkeletonLabel extends StatelessWidget {
  const SkeletonLabel({super.key, this.width = 90, this.height = 10});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => SkeletonBox(
        width: width,
        height: height,
        radius: 8,
      );
}
