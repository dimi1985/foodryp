import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;
  final Duration duration;

  const FlipCard({
    Key? key,
    required this.frontWidget,
    required this.backWidget,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  void flip() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isFront = !isFront;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => flip(),
      onExit: (_) => flip(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _animation.value * 3.1415927;
          final transform = Matrix4.rotationY(angle);
          if (angle >= 3.1415927 / 2) {
            transform.rotateY(3.1415927);
          }
          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle >= 3.1415927 / 2 ? widget.backWidget : widget.frontWidget,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
