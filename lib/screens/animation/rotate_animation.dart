import 'package:flutter/material.dart';

class CustomRotate extends StatefulWidget {
  const CustomRotate({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<CustomRotate> createState() => _CustomRotateState();
}

class _CustomRotateState extends State<CustomRotate> {
  double turns = 0;
  Duration duration = const Duration(milliseconds: 750);
  @override
  void initState() {
    rotate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: duration,
      child: widget.child,
    );
  }

  void rotate() async {
    setState(() {
      turns = 1;
    });
    await Future.delayed(duration);
    setState(() {
      turns = 0;
    });
  }
}
