import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/SongList.dart';
import 'package:music/ui/pages/SearchPage/SearchPage.dart';
import 'package:music/ui/pages/SongListPage.dart';
import 'package:music/ui/widget/HeightLightText.dart';
import 'package:music/ui/widget/HoverView.dart';



//歌单搜索页面
List<Widget> buildSongListSearchWidgets(SearchPageController controller, String keyword) {
  //列表项
  List<Widget> widgets = [];
  //读取json
  var result = controller.json["result"];
  // print(result);
  if(result != null && result["playlists"] != null){
    var songLists = jsonToSongLists(result["playlists"]);

    for (var item in songLists) {
      widgets.add(
          GestureDetector(
            onTap: (){
              global.navigationController.push(SongListPage(key: ValueKey("歌单:${item.id}"), songlist: item));
            },
            child: HoverView(
              height: 85,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  //封面
                  SizedBox(
                      width: 60, height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                            item.getCoverImgUrl + "?param=60y60",
                            errorBuilder: (context, error, stack){
                              return Image.asset("src/images/default_avatar.png");
                            }
                        ),
                      )
                  ),
                  const SizedBox(width: 20),
                  //歌单名称
                  Expanded(
                    flex: 5,
                    child: HeightLightText(text: item.name, keyword: keyword),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text("${item.trackCount}首", style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12)),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text("by ${item.creatorName}", style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Icon(FeatherIcons.playCircle, color: Color(0xFFAAAAAA), size: 16),
                        const SizedBox(width: 4),
                        Text(item.getPlayCount(), style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12)),
                      ],
                    )
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



