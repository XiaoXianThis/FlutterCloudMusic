import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/ui/widget/BottomBar.dart';
import 'package:music/ui/widget/LeftSideNavigationBar.dart';
import 'package:music/ui/widget/NavigationContainer.dart';
import 'package:music/ui/widget/TopAppBar.dart';
import '../api/Tools.dart';

class MainFrame extends StatelessWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "HarmonyOSSans",
      ),
      home: Material(
        child: Column(
          children: [
            //标题栏
            const SizedBox(height: 60, child: TopAppBar()),
            //主体
            Expanded(child: Row(
              children: [
                Container(
                  color: const Color(0xFFFFFFFF),
                  width: 210,
                  child: const LeftSideNavigationBar(),
                ),
                Container(width: 1, color: Colors.black12),
                Expanded(child: Container(
                  color: const Color(0xFFFFFFFF),
                  child: const NavigationContainer(),
                ))
              ],
            )),
            Container(height: 1, color: Colors.black12),
            //底栏 height:72
            Container(height: 72, color: Colors.white, child: const BottomBar(),)
          ],
        )
      )
    );
  }
}
