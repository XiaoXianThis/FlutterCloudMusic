import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/Song.dart';
import 'package:music/ui/pages/HomePage.dart';
import 'package:music/ui/pages/MyMusicPage.dart';
import 'package:music/ui/pages/NavigationPage.dart';
import 'package:music/ui/pages/SongListPage.dart';

//名字没写错， NavigationContainer在下面
class NavigationController extends GetxController {
  //页面栈
  var pageStack = [].obs;
  //前台页面
  Rx<NavigationPage> page = const NavigationPage(MyMusicPage).obs;


  //push进来的widget必须传入Key参数，用来判断是否需要加入
  void push(Widget page){
    // 如果页面的key不同，则添加
    if(page.key != this.page.value.child?.key){
      var parent = NavigationPage(page);
      //当前页面丢进栈
      pageStack.add(this.page.value);
      //切换成新的页面
      this.page.value = parent;
    }
  }

  //如果已经存在一个Key相同的界面, 则移动到顶部, 否则才创建页面
  // void pushOrMoveUP(){
  //
  // }

  void pop(){
    if(pageStack.isNotEmpty){
      if(page.value.child is SongListPage){
        (page.value.child as SongListPage).songlist.songs.clear();
      }
      page.value = pageStack.removeLast();
    }
  }
}

//承载动态页面的容器
class NavigationContainer extends StatelessWidget {
  const NavigationContainer({Key? key}) : super(key: key);

  @override Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Obx((){
        return (global.navigationController.page).value;
      }),
    );
  }
}


