import 'package:flutter/material.dart';

//一个逻辑容器，承载所有可导航的页面
class NavigationPage extends StatefulWidget {
  const NavigationPage(this.child, {Key? key}) : super(key: key);
  final Widget? child;
  @override State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}
