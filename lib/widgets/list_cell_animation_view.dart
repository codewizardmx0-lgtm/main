import 'package:flutter/material.dart';

class ListCellAnimationView extends StatelessWidget {
  final Animation<double> animation;
  final AnimationController animationController;
  final Widget child;
  final double yTranslation;

  const ListCellAnimationView({
    Key? key,
    required this.animation,
    required this.animationController,
    required this.child,
    this.yTranslation = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(0, yTranslation / 100), // يتحرك عموديًا
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
