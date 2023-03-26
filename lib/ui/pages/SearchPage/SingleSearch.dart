//单曲
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/Song.dart';
import 'package:music/ui/widget/SongItem.dart';
import 'SearchPage.dart';


//单曲搜索 页面
List<Widget> buildSingleSearchWidgets(SearchPageController controller, String keyword){
  //列表项
  List<Widget> widgets = [];
  //读取json
  var result = controller.json["result"];
  // print(json.encode(result));
  //为空就刷新
  if(result==null){ controller.search(keyword); }
  //不为空就解析
  else {
    var songs = result["songs"];
    // print(json.encode(songs));
    if(songs!=null) {
      for (var i = 0; i < songs.length; i++) {
        //单曲json对象
        var item = songs[i];
        // print(json.encode(item));
        //单曲song对象
        var song = jsonToSong(item, null);
        //创建列表项
        widgets.add(
          GestureDetector(
            onDoubleTap: () {
              //如果有版权
              if(song.copyright == true){
                //双击播放
                global.player.play(song);
              }
              else {
                var snackBarController = Get.showSnackbar(GetSnackBar(message: "${song.name} 暂无版权。", animationDuration: const Duration(milliseconds: 300)));
                Timer(const Duration(seconds: 3), (){snackBarController.close();});
              }
            },
            child: SongItem(song: song, index: i, heightLight: keyword),
          )
        );
      }
    }
  }
  //返回列表项
  return widgets;
}


