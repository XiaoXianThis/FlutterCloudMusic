import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/ui/widget/HoverView.dart';
import 'package:music/ui/widget/MiniSlider.dart';

class BottomRightButtons extends StatelessWidget {
  const BottomRightButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cacheVolume = 1.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //音量控制
        SizedBox(
          width: 105,
          child: Row(
            children: [
              //音量图标
              GestureDetector(
                child: HoverView(
                  child: Obx((){
                    return Icon((){
                      if(global.player.volume.value == 0){
                        return Icons.volume_off_rounded;
                      }
                      else if(global.player.volume.value < 0.3){
                        return Icons.volume_mute_rounded;
                      }
                      else if(global.player.volume.value < 0.6){
                        return Icons.volume_down_rounded;
                      }
                      else if(global.player.volume.value <= 1.0){
                        return Icons.volume_up_rounded;
                      }
                    }(), color: const Color(0xFF888888), size: 20);
                  }),
                  padding: const EdgeInsets.fromLTRB(11, 11, 11, 11),
                ),
                onTap: (){
                  if(global.player.volume.value > 0){
                    cacheVolume = global.player.volume.value;
                    global.player.setVolume(0);
                  } else {
                    global.player.setVolume(cacheVolume);
                  }
                },
              ),
              //音量滑动条
              Obx((){
                return MiniSlider(value: global.player.volume.value, onChanged: (value){
                  global.player.setVolume(value);
                });
              }),
            ],
          ),
        ),  //音量控制

        const SizedBox(width: 8),
        //播放列表图标
        GestureDetector(
          child: HoverView(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: const Icon(Icons.playlist_play_rounded, color: Color(0xff888888)),
          ),
        ),

        const SizedBox(width: 12),
      ],
    );
  }
}
