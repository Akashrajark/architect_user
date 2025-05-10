import 'package:flutter/material.dart';

class WidthBound extends StatelessWidget {
  final Widget child;
  final double width;
  const WidthBound({super.key, required this.child, this.width = 1200});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        child: child,
      ),
    );
  }
}
