import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/Song.dart';
import 'package:music/ui/pages/SearchPage/SearchPage.dart';



//Spotify搜索页面
List<Widget> buildSpotifySearchWidgets(SearchPageController controller, String keyword) {
  //列表项
  List<Widget> widgets = [];
  widgets.add(const Text("开发中"));
  //读取json
  var tracks = controller.json["tracks"];
  if(tracks!=null){
    List<dynamic> items = tracks["items"];
    // print(items.length);
    for (var i = 0; i<items.length; i++) {
      //单曲json对象
      var item = items[i];
      // print(item["name"]);
      //单曲song对象
      var song = Song(
          item["id"],
          item["name"],
          (() {
            var result = "";
            List<dynamic> artists = item["artists"];
            for (var item in artists) {
              result += "${item["name"]}/";
            }
            result = result.substring(0, result.length - 1);
            return result;
          }()),
          item["album"]["name"],
          SongPlatform.spotify,
        json: item
      );
      widgets.add(
          GestureDetector(
            //双击播放
            onDoubleTap: () async {
              // global.player.play(song);
              var snackBarController = Get.showSnackbar(const GetSnackBar(message: "第三方平台播放功能开发中", animationDuration: Duration(milliseconds: 300)));
              Timer(const Duration(seconds: 3), (){snackBarController.close();});
            },
            child: Container(
              height: 40,
              color: Color(() {
                if (i % 2 == 0) {
                  return 0xFFFAFAFA;
                }
                else {
                  return 0x00FAFAFA;
                }
              }()),
              child: Row(
                children: [
                  //序号
                  const SizedBox(width: 20),
                  Text("${(() {
                    if (i + 1 < 10) {
                      return "0";
                    } else {
                      return "";
                    }
                  }())}${i + 1}",
                      style: const TextStyle(color: Colors.black26)),

                  //下载图标
                  const SizedBox(width: 12),
                  const Icon(
                    FeatherIcons.download, size: 16, color: Colors.black26,),

                  //歌曲名
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      child: Row(
                        children: [
                          //歌曲名称
                          Flexible(
                            child: Text(
                              (() {
                                var result = song.name;
                                // List<dynamic> alias = item["alias"];
                                // if(alias.isNotEmpty){ result += "（${alias[0]}）"; }
                                return result;
                              }()),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 50,
                  ),

                  //歌手
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                      child: Text(
                        song.artists,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    flex: 20,
                  ),

                  //专辑名称
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: Text(song.album, softWrap: false,
                            overflow: TextOverflow.ellipsis)),
                    flex: 20,
                  ),
                ],
              ),
            ),
          )
      );
    }
  }
  return widgets;
}



