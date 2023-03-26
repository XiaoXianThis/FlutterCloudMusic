import 'package:flutter/material.dart';
import 'package:music/data/Artist.dart';
import 'package:music/ui/pages/SearchPage/SearchPage.dart';
import 'package:music/ui/widget/HeightLightText.dart';
import 'package:music/ui/widget/HoverView.dart';



//歌手搜索页面
List<Widget> buildArtistSearchWidgets(SearchPageController controller, String keyword) {
  //列表项
  List<Widget> widgets = [];
  //读取json
  var result = controller.json["result"];
  // print(result);
  if(result != null && result["artists"] != null){
    List<Artist> artists = jsonToArtists(result["artists"]);
    for (var item in artists) {
      widgets.add(
          HoverView(
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
                          item.getPicUrl + "?param=60y60",
                          errorBuilder: (context, error, stack){
                            return Image.asset("src/images/default_avatar.png");
                          }
                      ),
                    )
                ),
                const SizedBox(width: 20),
                //专辑名称
                Expanded(
                  child: HeightLightText(text: item.name, keyword: keyword),
                ),
              ],
            ),
          )
      );
    }
  }
  return widgets;
}



