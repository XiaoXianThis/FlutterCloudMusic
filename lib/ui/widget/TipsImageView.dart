import 'package:flutter/material.dart';


//带图片和文字的提示布局
class TipsImageView extends StatelessWidget {
  const TipsImageView({Key? key, required this.image, required this.text, this.opacity = 1, this.height = 120 }) : super(key: key);

  final Image image;
  final Text text;
  final double opacity;
  final double height;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: opacity,
        child: SizedBox(
          height: height,
          child: Column(
            children: [
              Expanded(child: image),
              const SizedBox(height: 8),
              text
            ],
          ),
        ),
      ),
    );
  }
}

