import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/ui/widget/HoverView.dart';
import 'package:music/ui/widget/TipsImageView.dart';

//日志类型
enum MessageType {
  debug,
  warning,
  error
}
//一条日志消息
class Message {
  MessageType type = MessageType.debug;
  String value = "";
  Message(this.type, this.value);
}

//日志控制器
class LogsController extends GetxController {
  var logs = <Message>[].obs;                //日志缓冲区

  //当条件成立，则添加一条信息
  void _add(Message message){
    if(global.settings.debugMode.isTrue) logs.add(message);
  }
  //打印一条普通信息
  void debug(String message){
    _add(Message(MessageType.debug, message));
  }
  //打印一条警告信息
  void warning(String message){
    _add(Message(MessageType.warning, message));
  }
  //打印一条错误信息
  void error(String message){
    _add(Message(MessageType.error, message));
  }
}

//日志页面
const LogPage = _LogPage();
class _LogPage extends StatelessWidget {
  const _LogPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = logs;
    return Obx((){
      if(global.settings.debugMode.isFalse){
        return TipsImageView(
          image: Image.asset("src/images/QYN_let_go.png"),
          text: const Text("你双击了LOGO所以进入了一个彩蛋页面"),
          opacity: 0.15,
        );
      }
      else {
        return DynMouseScroll(
          builder: (ctx, scrollController, physics){
            return CustomScrollView(
              controller: scrollController,
              physics: physics,
              slivers: [
                const SliverPadding(padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
                  sliver: SliverToBoxAdapter(
                      child: Text("运行日志",  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))
                  ),
                ),

                SliverPadding(padding: const EdgeInsets.fromLTRB(32, 0, 32, 20),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        var message = controller.logs[controller.logs.length-1-index];
                        return HoverView(
                            hoverColor: (){
                              if(message.type == MessageType.warning) {
                                return const Color(0xFFFFFAED);
                              }
                              else if(message.type == MessageType.error) {
                                return const Color(0xFFFFF6F6);
                              }
                              else {
                                return const Color(0xFFFAFAFA);
                              }
                            }(),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: TextSelectionTheme(
                              data: const TextSelectionThemeData(
                                selectionColor: Colors.white,//选中文字背景颜色
                              ),
                              child: SelectableText(message.value,style: TextStyle(
                                color: (){
                                  if(message.type == MessageType.warning) {
                                    return const Color(0xFFFFB300);
                                  }
                                  else if(message.type == MessageType.error) {
                                    return const Color(0xFFF70000);
                                  }
                                  else {
                                    return const Color(0xFF555555);
                                  }
                                }(),
                              )),
                            )
                        );
                      }, childCount: controller.logs.length)
                  ),
                ),
              ],
            );
          },
          // animationCurve: Curves.decelerate,
          // flickAnimationCurve: Curves.linear,

        );
      }
    });
  }

}

