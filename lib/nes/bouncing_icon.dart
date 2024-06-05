import 'package:flutter/material.dart';

class BouncingIcon extends StatefulWidget {
  const BouncingIcon({
    super.key,
    required this.icon,
  });

  final Widget icon;

  @override
  State<BouncingIcon> createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  )
    ..forward()
    ..addStatusListener((AnimationStatus status) {
      switch (status) {
        case AnimationStatus.completed:
          // got to top, now reverse back to original position
          _controller.reverse();
        case AnimationStatus.dismissed:
          // got back to original position, wait 300ms before starting again
          Future.delayed(
              const Duration(milliseconds: 300), _controller.forward);
        default:
          break;
      }
    });

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.25),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  ));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      transformHitTests: false,
      child: widget.icon,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
