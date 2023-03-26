import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/api/login.dart';
import 'package:music/data/Global.dart';

//二维码状态
enum StateCode {
  expire,   //二维码已过期（800）
  normal,   //正常显示（801）
  waiting,  //待确认（802）
  success,  //登录成功（803）
}

class QRCodeController extends GetxController {
  var stateCode = StateCode.expire.obs;
  var qrcodeUint8 = Uint8List(0).obs;
  //刷新二维码用的计时器
  Timer? timer;
  //停止二维码刷新
  void stopRefresh() {
    timer?.cancel();
  }
}

class QRCode extends StatelessWidget {
  QRCode({Key? key, this.onSuccessCallback }) : super(key: key);

  Function? onSuccessCallback;

  @override
  Widget build(BuildContext context) {
    QRCodeController controller = Get.find();
    login();
    return ((){
      return Container(
        width: 250, height: 250,
        child: Center(
          child: Obx((){
            if(controller.stateCode.value == StateCode.expire){
              return Text("二维码已过期, 等待刷新");
            }
            return Image.memory(controller.qrcodeUint8.value);
          }),
        ),
      );
    }());
  }

  void login() async {
    QRCodeController controller = Get.find();
    String qrkey = await login_qrkey();
    //登录前重置状态
    controller.qrcodeUint8.value = await login_qrcode(qrkey);
    controller.stateCode.value = StateCode.normal;
    //每五秒检测一次二维码状态
    controller.timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      // print("状态:${controller.stateCode.value}");
      //如果过期就刷新
      if(controller.stateCode.value == StateCode.expire){
        qrkey = await login_qrkey();
        controller.qrcodeUint8.value = await login_qrcode(qrkey);
        controller.stateCode.value = StateCode.normal;
      }
      //如果登录成功就关闭
      else if (controller.stateCode.value == StateCode.success){
        timer.cancel();
      }
      //如果正常状态，就检测二维码是否过期，并且更新状态
      else {
        // {code: 801, message: 等待扫码, cookie: }  //(803 状态码下会返回 cookies)
        var json = await login_check(qrkey);
        var code = json["code"];
        //过期
        if(code == 800) {
          controller.stateCode.value = StateCode.expire;
        } else if(code == 801) {
          controller.stateCode.value = StateCode.normal;
        } else if(code == 802) {
          controller.stateCode.value = StateCode.waiting;
        } else if(code == 803) {
          controller.stateCode.value = StateCode.success;
          if(onSuccessCallback!=null) onSuccessCallback!(json["cookie"]);
        } else {
          controller.stateCode.value = StateCode.success;
          if(onSuccessCallback!=null) onSuccessCallback!();
          logs.error("二维码登录状态遇到其他情况:$json");
        }
      }
    });
  }
}

