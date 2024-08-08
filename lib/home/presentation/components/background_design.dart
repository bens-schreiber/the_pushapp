import "package:flutter/material.dart";

class BackgroundDesign extends StatelessWidget {
  const BackgroundDesign({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const CircleDesign(opacity: 1, height: 300, width: 300),
        const CircleDesign(opacity: 1, height: 325, width: 325),
        const CircleDesign(opacity: 0.7, height: 375, width: 375),
        const CircleDesign(opacity: 0.7, height: 475, width: 475),
        const CircleDesign(opacity: 0.7, height: 650, width: 650),
        child,
      ],
    );
  }
}

class CircleDesign extends StatelessWidget {
  const CircleDesign(
      {required this.opacity,
      required this.height,
      required this.width,
      super.key});
  final double height;
  final double width;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: height,
      width: width,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).focusColor, width: 3.0),
          ),
        ),
      ),
    );
  }
}
