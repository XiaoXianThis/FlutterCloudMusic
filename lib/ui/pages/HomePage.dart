import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/ui/widget/TipsImageView.dart';

const HomePage = _HomePage();
class _HomePage extends StatelessWidget {
  const _HomePage({ Key? key = const ValueKey("发现页面") }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TipsImageView(
        image: Image.asset("src/images/QYN_let_go.png"),
        text: const Text("首页开发中"),
        opacity: 0.15,
    );
  }
}


