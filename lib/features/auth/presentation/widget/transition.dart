import 'package:flutter/material.dart';

class SlideTransition1 extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;
  final Curve forwardCurve;
  final Curve reverseCurve;
  final Duration forwardDuration;
  final Duration reverseDuration;

  SlideTransition1({
    required this.page,
    this.direction = AxisDirection.left,
    this.forwardCurve = Curves.fastLinearToSlowEaseIn,
    this.reverseCurve = Curves.fastOutSlowIn,
    this.forwardDuration = const Duration(milliseconds: 2000),
    this.reverseDuration = const Duration(milliseconds: 600),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: forwardDuration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: forwardCurve,
              reverseCurve: reverseCurve,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: _getBeginOffset(direction),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );

  static Offset _getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(1, 0);
      case AxisDirection.right:
        return const Offset(-1, 0);
    }
  }
}

class SlideTransition2 extends PageRouteBuilder {
  final Widget page;
  final AxisDirection direction;
  final Curve forwardCurve;
  final Curve reverseCurve;
  final Duration forwardDuration;
  final Duration reverseDuration;

  SlideTransition2({
    required this.page,
    this.direction = AxisDirection.right,
    this.forwardCurve = Curves.fastLinearToSlowEaseIn,
    this.reverseCurve = Curves.fastOutSlowIn,
    this.forwardDuration = const Duration(milliseconds: 2000),
    this.reverseDuration = const Duration(milliseconds: 600),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: forwardDuration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
              parent: animation,
              curve: forwardCurve,
              reverseCurve: reverseCurve,
            );
            return SlideTransition(
              position: Tween<Offset>(
                begin: _getBeginOffset(direction),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );

  static Offset _getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(1, 0);
      case AxisDirection.right:
        return const Offset(-1, 0);
    }
  }
}
