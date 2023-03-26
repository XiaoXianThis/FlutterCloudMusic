import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/ui/widget/TipsImageView.dart';

import '../../data/Global.dart';
import 'SongListPage.dart';

//我喜欢的音乐 页面
const MyMusicPage = _MyMusicPage();
class _MyMusicPage extends StatelessWidget {
  const _MyMusicPage({ Key? key = const ValueKey("我喜欢的音乐") }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Container(
        child: (){
          if(global.localUser.login.isTrue){
            var songlist = global.localUser.songLists;
            if(songlist.isNotEmpty){
              return SongListPage(
                songlist: global.localUser.songLists[0],
                key: ValueKey("歌单:${songlist[0].id}"),
              );
            }
          }
          return TipsImageView(
            image: Image.asset("src/images/QYN_let_go.png"),
            text: const Text("你还没登录呢"),
            opacity: 0.15,
          );
        }(),
      );
    });
  }
}

