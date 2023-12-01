import 'package:flutter/material.dart';

class NavigationMixin {
  PageRouteBuilder fadeRouteBuilder(BuildContext context, Widget page,
      [Duration duration, dynamic args, String name]) {
    duration = duration ?? 500;
    return PageRouteBuilder(
      opaque: true,
      transitionDuration: duration,
      settings: RouteSettings(arguments: args, name: name),
      pageBuilder: (BuildContext context, _, __) => page,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  PageRouteBuilder slideRightRouteBuilder(BuildContext context, Widget page,
      [Duration duration, dynamic args, String name]) {
    duration = duration ?? 500;
    return PageRouteBuilder(
      opaque: true,
      transitionDuration: duration,
      settings: RouteSettings(arguments: args, name: name),
      pageBuilder: (BuildContext context, _, __) => page,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) =>
          SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );
  }
}
