import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/data/Song.dart';
import '../../data/Player.dart';
import 'HeightLightText.dart';
import 'HoverView.dart';

class SongItem extends StatelessWidget {
  const SongItem({Key? key, required this.song, required this.index, this.heightLight = ""}) : super(key: key);

  final Song song;
  final int index;
  final String heightLight;       //要高亮显示的关键字

  @override
  Widget build(BuildContext context) {
    return HoverView(
      height: 45,
      normalColor: (){ if(index%2==0) return const Color(0xFFFAFAFA); }(),
      child: Row(
        children: [
          //序号
          SizedBox(
              width: 45,
              child: Text(
                  "${(() {if (index + 1 < 10) {return "0";} else {return "";}}())}${index + 1}",
                  style: const TextStyle(color: Colors.black26),
                  textAlign: TextAlign.right
              )
          ),


          //喜欢图标
          // const SizedBox(width: 8),
          IconButton(onPressed: (){
            song.like();
          }, icon: Obx((){
            if(song.isLike.value){
              return const Icon(Icons.favorite_rounded, size: 18, color: Colors.red);
            }
            return const Icon(Icons.favorite_border_rounded, size: 18);
          })),

          //下载图标
          // const SizedBox(width: 12),
          GestureDetector(
            onTap: (){ song.download(); },
            child: const Icon(FeatherIcons.download, size: 16, color: Colors.black26),
          ),

          //歌曲名
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: Row(
                children: [
                  //歌曲名称
                  Flexible(
                    child: HeightLightText(
                      text: (() {
                        var result = song.name;
                        // List<dynamic> alias = item["alias"];
                        // if(alias.isNotEmpty){ result += "（${alias[0]}）"; }
                        return result;
                      }()),
                      keyword: heightLight,
                      color: (){
                        if(song.copyright == true){
                          return 0xFF333333;
                        }
                        else {
                          return 0xFFCCCCCC;
                        }
                      }(),
                    )
                  ),

                  //会员标识
                      () {
                    // 1：VIP歌曲, 8，0：免费歌曲
                    var fee = song.json["fee"];
                    if (fee == 1) {
                      return Row(
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: const Color(0xFFFE672E))
                            ),
                            child: const Text(" VIP ", style: TextStyle(fontSize: 10, color: Color(0xFFFE672E))),
                          ),
                        ],
                      );
                    }
                    else {
                      return const SizedBox();
                    }
                  }(),
                  //SQ 和 HiRes 标识
                      () {
                    var text = "";
                    var hires = song.json["hr"];
                    var sq = song.json["sq"];
                    if (hires != null) {
                      text = " HiRes ";
                    }
                    else if (sq != null) {
                      text = " SQ ";
                    }
                    else {
                      return const SizedBox();
                    }
                    return Row(
                      children: [
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFEC4141))
                          ),
                          child: Text(text, style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFFEC4141),
                              leadingDistribution: TextLeadingDistribution.proportional)
                          ),
                        ),
                      ],
                    );
                  }(),
                ],
              ),
            ),
            flex: 50,
          ),

          //歌手
          Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: HeightLightText(
                  text: song.artists,
                  keyword: heightLight,
                )
            ),
            flex: 20,
          ),

          //专辑名称
          Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: HeightLightText(
                  text: song.album,
                  keyword: heightLight,
                )
            ),
            flex: 20,
          ),
          Expanded(child: Text(durationToString(Duration(milliseconds: song.json["dt"] ?? 0)), style: const TextStyle(color: Color(0xFFAAAAAA)),), flex: 10),
        ],
      ),
    );
  }
}
