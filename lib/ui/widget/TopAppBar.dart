import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/api/LoadCore.dart';
import 'package:music/data/Global.dart';
import 'package:music/ui/pages/LogsPage.dart';
import 'package:music/ui/pages/SearchPage/SearchPage.dart';
import 'package:music/ui/pages/SettingsPage.dart';
import 'package:music/ui/widget/LoginDialog.dart';
import 'package:music/ui/widget/LogoWidget.dart';
import 'package:music/ui/widget/UserDialog.dart';
import 'package:music/ui/widget/VipLogo.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class TopAppBar extends StatefulWidget {
  const TopAppBar({Key? key}) : super(key: key);

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 8, 0),
        child: Row(
          children: [
            //图标
            GestureDetector(
              onDoubleTap: (){
                //如果调试模式则跳到日志页
                // if(logs.debugMode==true) global.navigationController.push(LogPage);
                global.navigationController.push(LogPage);
              },
              child: const LogoWidget(),
            ),

            //导航键
            IconButton(onPressed: (){ global.navigationController.pop(); }, icon: const Icon(Icons.keyboard_arrow_left), color: Colors.black54,),
            IconButton(onPressed: (){  }, icon: const Icon(Icons.keyboard_arrow_right), color: Colors.black54,),
            const Padding(padding: EdgeInsets.fromLTRB(2, 0, 0, 0)),
            //搜索框
            Container(
              decoration: const BoxDecoration(color: Color(0xFFEBEBEB), borderRadius: BorderRadius.all(Radius.circular(90))),
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              width: 160,
              height: 32,
              //搜索框
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(fontSize: 14),
                onEditingComplete: (){
                  doSearch(textEditingController.text);
                },
                cursorWidth: 1,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                  border: OutlineInputBorder(borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                  prefixIcon: Icon(FeatherIcons.search, size: 16),
                  hintText: "搜索",
                  hintStyle: TextStyle(color: Color(0xFFBBBBBB)),
                  prefixIconConstraints: BoxConstraints(maxWidth: 26, minWidth: 26),

                ),
              ),
            ),
            Expanded(child: MoveWindow()),

            //头像
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                color: const Color(0x01FFFFFF),
                child: Obx((){
                  return GestureDetector(
                    onTap: ((){
                      if(global.localUser.login.isTrue){
                        return () => showUserDialog(context);
                      } else {
                        return () => showLoginDialog();
                      }
                    }()),
                    child: Row(
                      children: [
                        //头像
                        ClipOval(
                          child: Image.network(
                            global.localUser.avatarUrl.value + "?param=30y30",   //param控制图片宽高
                            width: 30, height: 30,
                            errorBuilder: (ctx, err, stack) => Image.asset("src/images/default_avatar.png"),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                        Text(((){
                          if(global.localUser.login.value){
                            return global.localUser.name.value;
                          } else {
                            return "登录";
                          }
                        }()), style: TextStyle(fontSize: 12)),
                        const Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
                        VipLogo(),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
            //设置按钮
            IconButton(onPressed: (){
              global.navigationController.push(SettingsPage);
            }, icon: const Icon(FeatherIcons.settings), color: Colors.black54, iconSize: 18,),
            const Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0)),
            Container(width: 1, height: 15,color: Colors.black38),

            Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(4), child: MinimizeWindowButton(
                  colors: WindowButtonColors(
                    mouseOver: const Color(0xFFAAAAAA),
                  ),
                )),
                ClipRRect(borderRadius: BorderRadius.circular(4), child: MaximizeWindowButton(
                  colors: WindowButtonColors(
                    mouseOver: const Color(0xFFAAAAAA),
                  ),
                )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CloseWindowButton(
                    onPressed: (){
                      closeCore();
                      appWindow.close();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//执行搜索
void doSearch(String keyword){
  global.navigationController.push(SearchPage(keyword: keyword, key: ValueKey("搜索:$keyword")));
}
