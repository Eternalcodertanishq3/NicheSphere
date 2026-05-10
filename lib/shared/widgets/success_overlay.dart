import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessOverlay extends StatefulWidget {
  final VoidCallback onCompleted;
  final bool showConfettiAfter;
  final double size;

  const SuccessOverlay({
    required this.onCompleted,
    this.showConfettiAfter = false,
    this.size = 160,
    super.key,
  });

  @override
  State<SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<SuccessOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _playedConfetti = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if (widget.showConfettiAfter && !_playedConfetti) {
          setState(() => _playedConfetti = true);
          // small delay so confetti feels like a follow-up
          await Future.delayed(const Duration(milliseconds: 220));
          // keep confetti looping briefly then finish
          await Future.delayed(const Duration(milliseconds: 900));
        }
        widget.onCompleted();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFallbackIcon(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
      ),
      child: Icon(Icons.check_rounded, size: widget.size * 0.5, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // dim background
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // block touches while overlay is visible
              child: Container(color: Colors.black26),
            ),
          ),
          // main animation container
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: Lottie.asset(
              'assets/animations/success_check.json',
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
              errorBuilder: (_, __, ___) => _buildFallbackIcon(context),
            ),
          ),
          // optional confetti overlay
          if (_playedConfetti)
            Positioned(
              top: 0,
              child: SizedBox(
                width: widget.size * 2.0,
                height: widget.size * 2.0,
                child: Lottie.asset(
                  'assets/animations/confetti_burst.json',
                  repeat: false,
                  onLoaded: (_) {},
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
