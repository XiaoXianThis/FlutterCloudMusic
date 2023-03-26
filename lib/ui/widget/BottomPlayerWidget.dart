import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/Player.dart';
import 'package:music/ui/widget/BottomSilder.dart';
import 'package:music/ui/widget/HoverView.dart';

class BottomPlayerWidget extends StatelessWidget {
  const BottomPlayerWidget({Key? key}) : super(key: key);

  @override Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 4),
        //控制按钮
        SizedBox(
          height: 40,
          width: 260,
          child: Align(
            child: Row(
              children: [
                //播放模式
                Expanded(child: HoverView(child: IconButton(onPressed: (){
                  global.player.changePlayMode();
                }, icon: Obx((){
                  return Icon((){
                    if(global.player.playMode.value == PlayMode.sequential) return Icons.format_list_bulleted;   //顺序播放
                    if(global.player.playMode.value == PlayMode.loop) return Icons.repeat_one_rounded;        //单曲循环
                    if(global.player.playMode.value == PlayMode.listLoop) return Icons.repeat_rounded;    //列表循环
                    return Icons.shuffle;   //随机播放
                  }(), size: 20,);
                })))),
                //上一曲
                Expanded(child: HoverView(child: IconButton(onPressed: (){ global.player.back(); }, icon: const Icon(Icons.skip_previous_rounded)))),
                Expanded(child: HoverView(
                  // color: const Color(0xffF5F5F5),
                  // decoration: BoxDecoration(color: const Color(0xffF5F5F5), borderRadius: BorderRadius.circular(8)),
                  child: Obx((){
                    return IconButton(
                        onPressed: (){
                          if(global.player.isPlaying.isTrue){ global.player.pause(); }
                          else { global.player.start(); }
                        },
                        icon: (){
                          if(global.player.isPlaying.value == true){
                            return const Icon(Icons.pause_rounded);
                          }
                          else {
                            return const Icon(Icons.play_arrow_rounded);
                          }
                        }()
                    );
                  }),
                )),
                //下一曲
                Expanded(child: HoverView(child: IconButton(onPressed: (){ global.player.next(); }, icon: const Icon(Icons.skip_next_rounded, size: 24,)))),
                //喜欢的红心
                Expanded(child: HoverView(
                    child: IconButton(
                        onPressed: (){
                          global.player.song.value.like();
                        },
                        icon: Obx((){
                          if(global.player.song.value.isLike.value){
                            return const Icon(Icons.favorite_rounded, size: 20, color: Colors.red);
                          }
                          return const Icon(Icons.favorite_border_rounded, size: 20);
                        })
                    )
                )),
              ],
            ),
          ),
        ),

        //进度条
        Expanded(
          child: SizedBox(
            width: 470,
            height: 10,
            child: Row(
              children: [
                //当前进度
                SizedBox(
                    width: 50,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Obx((){
                          return Text(
                              global.player.progressText.value,
                              style: const TextStyle(fontSize: 11, color: Colors.black45)
                          );
                        }),
                    )
                ),
                // const SizedBox(width: 10),
                //滑块
                Expanded(
                    child: Obx((){
                      return BottomSlider((){
                        var result = global.player.progress.value.inSeconds / global.player.duration.value.inSeconds;
                        if(result>=0 && result<=1) { return result; }
                        else { return 0.0; }
                      }());
                    }),
                ),
                // const SizedBox(width: 10),
                //总时长
                SizedBox(
                    width: 50,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Obx((){
                          return Text(
                              global.player.durationText.value,
                              style: TextStyle(fontSize: 11, color: Colors.black45)
                          );
                        }),
                    )
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}

