import 'package:flutter/material.dart';

class BottomTopMoveAnimationView extends StatelessWidget {
  final AnimationController animationController;
  final Widget child;

  const BottomTopMoveAnimationView(
      {Key? key, required this.child, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // إنشاء Animation<Offset> للحركة من الأسفل للأعلى
    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1), // بداية من أسفل الشاشة
      end: Offset.zero, // النهاية في مكانها الطبيعي
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    return FadeTransition(
      opacity: animationController,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
