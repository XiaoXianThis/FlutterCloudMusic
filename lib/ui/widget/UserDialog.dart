import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/api/login.dart';
import 'package:music/data/Global.dart';
import 'package:music/ui/widget/HoverButton.dart';
import 'package:music/ui/widget/VipLogo.dart';


//点击用户头像时的弹窗
Future<void> showUserDialog(context) async {
  // showDialog(
  //   context: context,
  //   barrierColor: const Color(0x11000000),
  //   builder: (context){
  //     return
  //   }
  // );

  Get.dialog(
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 100, 0),
          child: Material(
            color: const Color(0x00FFFFFF),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 300,  height: 480,
                color: Colors.white,
                child: Obx((){
                  return Column(
                    children: [
                      //头图
                      Expanded(
                          child: Image.network(
                            global.localUser.backgroundUrl.value,
                            width: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Image.asset("src/images/default_avatar.png"),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Column(
                                  children: [
                                    Text("${global.localUser.listenSongs.value}", style: const TextStyle(color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.bold)),
                                    const Text("听过歌曲"),
                                  ],
                                )),
                                Expanded(child: Column(
                                  children: [
                                    Text("${global.localUser.follows.value}", style: const TextStyle(color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.bold)),
                                    const Text("关注"),
                                  ],
                                )),
                                Expanded(child: Column(
                                  children: [
                                    Text("${global.localUser.followeds.value}", style: const TextStyle(color: Color(0xff333333), fontSize: 20, fontWeight: FontWeight.bold)),
                                    const Text("粉丝"),
                                  ],
                                )),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const HoverButton(0,
                                FeatherIcons.zap,
                                "我的会员",
                                rightWidget: VipLogo(size: VipLogoSize.M),
                            ),
                            HoverButton(0,
                                FeatherIcons.award,
                                "等级",
                                rightWidget: Container(
                                    child: Text("Lv${global.localUser.level.value}", style: const TextStyle()), decoration: BoxDecoration(border: Border.all(color: const Color(0x00000000)), borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.fromLTRB(6, 0, 6, 2)),
                            ),
                            GestureDetector(
                              onTap: (){ logout(); Get.back(); },
                              child: const HoverButton(0, FeatherIcons.logOut, "退出登录"),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    barrierColor: const Color(0x11000000),
  );
}


