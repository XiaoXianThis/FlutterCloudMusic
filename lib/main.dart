import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music/api/LoadCore.dart';
import 'package:music/data/Global.dart';
import 'package:music/ui/MainFrame.dart';

void main() async {
  //运行核心
  loadCore();
  //初始化存储
  await GetStorage.init();
  //初始化全局变量对象
  global = GlobalClass();
  //运行主窗口
  runApp(const MainFrame());
  //窗口显示后操作
  doWhenWindowReady((){
    appWindow.show();
    appWindow.size = const Size(1024, 670);
    appWindow.minSize = const Size(1024, 670);
  });
}

