import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/ui/widget/QRCode.dart';

void showLoginDialog() async {
  QRCodeController controller = Get.find();
  Get.dialog(
    Center(
      child: Material(
        color: const Color(0x00FFFFFF),
        child: Container(
          width: 400, height: 400,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              const SizedBox(height:12),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  GestureDetector(
                      onTap: (){
                        Get.back();
                        controller.stopRefresh();
                      }, child: const Icon(FeatherIcons.x)
                  ),
                  const SizedBox(width: 24)
                ],
              ),
              const Text("扫码登录",style: TextStyle(fontSize: 20)),
              QRCode(
                //登录成功回调，并取得cookie
                onSuccessCallback: (cookie){
                  storage.write("cookie", cookie);  //保存cookie
                  global.localUser.refresh();            //刷新登录
                  controller.stopRefresh();         //停止二维码更新
                  Get.back();                       //关闭弹窗
                }
              ),
              const Text("使用网易云音乐APP扫码登录",style: TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              const Text("其他登录方式暂不支持", style: TextStyle(fontSize: 12, color: Colors.black38)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}

