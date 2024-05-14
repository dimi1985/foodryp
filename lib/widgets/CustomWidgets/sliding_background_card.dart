import 'package:flutter/material.dart';

class SlidingBackgroundCard extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;
  final Duration duration;

  const SlidingBackgroundCard({
    Key? key,
    required this.frontWidget,
    required this.backWidget,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _SlidingBackgroundCardState createState() => _SlidingBackgroundCardState();
}

class _SlidingBackgroundCardState extends State<SlidingBackgroundCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.2), // Adjust this value to control the slide distance
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void _onHover(bool hovering) {
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: Stack(
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: widget.backWidget,
          ),
          widget.frontWidget,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
