import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';


//底部封面歌曲名
class BottomLeftWidget extends StatelessWidget {
  const BottomLeftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12),
        SizedBox(
          width: 54, height: 54,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Obx((){
              return Image.network(
                  global.player.song.value.getPicUrl + "?param=108y108",
                  errorBuilder: (ctx, err, stack) => Container(
                    color: const Color(0xFFF44336),
                    child: const Icon(Icons.album, size: 90,),
                  ),
              );
            })
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Expanded(child: Align(alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 150,
                    child: Obx((){
                      return Text((){
                        if(global.player.song.value.name == "") { return "快去找一首歌听吧"; }
                        return global.player.song.value.name;
                      }(), style: const TextStyle(fontSize: 15), softWrap: false, overflow: TextOverflow.fade);
                    }),
                  )
              )),
              Expanded(child: Align(alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 150,
                    child: Obx((){
                      return Text((){
                        if(global.player.song.value.name == "") { return "简易云音乐"; }
                        return global.player.song.value.artists;
                      }(), softWrap: false, overflow: TextOverflow.fade);
                    }),
                  )
              )),
            ],
          ),
        ),
      ],
    );
  }
}

