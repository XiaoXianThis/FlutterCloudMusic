import 'package:flutter/material.dart';

import '../widget/TipsImageView.dart';


const FMPage = _FMPage();
class _FMPage extends StatelessWidget {
  static const String pageKey = "私人FM";
  const _FMPage({ Key? key = const ValueKey(pageKey) }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipsImageView(
      image: Image.asset("src/images/QYN_let_go.png"),
      text: const Text("私人FM 开发中"),
      opacity: 0.15,
    );
  }
}


