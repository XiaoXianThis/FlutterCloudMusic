import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/ui/widget/LogoWidget.dart';
import 'package:music/ui/widget/SettingsTop.dart';
import 'package:music/ui/widget/TipsImageView.dart';


//设置页
const SettingsPage = _SettingsPage();
class _SettingsPage extends StatelessWidget {
  const _SettingsPage({ Key? key = const ValueKey("设置页面") }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          sliver: SliverToBoxAdapter(
            child: About(),
          ),
        ),

      ],
    );
  }
}