import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



/*
好像偏离了我原本的想法了，我重新整理一下要求吧。
1.写一个全局函数，用getx框架弹出一个SnackBar，3秒后自动关闭
2.如果重复调用这个函数，则提前关掉之前的SnackBar，显示新的SnackBar
3.不需要传入BuildContext
*/

var timer = Timer(const Duration(milliseconds: 1), () { });
SnackbarController? snackbarController;
void toast(String message) {
  snackbarController?.close(withAnimations: false);
  snackbarController = Get.showSnackbar(GetSnackBar(message: message, animationDuration: const Duration(milliseconds: 300)));
  timer.cancel();
  timer = Timer(const Duration(seconds: 3), () async{
    print("timer:run");
    snackbarController?.close(withAnimations: true);
    snackbarController = null;
  });
}




//将数字转为带单位的字符串
String parseCount(int count){
  // 0~9999
  if(count < 10000){
    return "$count次";
  }
  // 1w ~ 9999w
  else if(count < 100000000){
    return "${ count ~/ 10000 }万";
  }
  // 1亿 以上
  else {
    return "${ count ~/ 100000000 }亿";
  }
}
