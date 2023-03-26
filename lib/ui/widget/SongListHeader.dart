import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/SongList.dart';
import 'package:music/ui/widget/HoverView.dart';
import 'package:readmore/readmore.dart';

class SongListHeader extends StatelessWidget {
  const SongListHeader({Key? key, required this.songlist}) : super(key: key);

  final SongList songlist;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //封面
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE))
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 200, height: 200,
              child: Image.network(
                songlist.getCoverImgUrl + "?param=400y400",
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: const Color(0xFFF44336),
                  child: const Icon(Icons.album, size: 90,),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        //左侧布局
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:8),
            //标题
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 类型标签 [歌单/专辑]
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFEC4141))),
                    child: const Text("歌单", style: TextStyle(color: Color(0xFFEC4141))),
                  ),
                ),
                const SizedBox(width: 12),
                //标题（最多为20个汉字）
                Expanded(child: Text(songlist.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)))
              ],
            ),
            const SizedBox(height:8),
            //创建者信息
            Row(
              children: [
                Text(songlist.creatorName, style: const TextStyle(color: Color(0xFF507DAF)),),
                const SizedBox(width: 6),
                const Text("创建"),
              ],
            ),
            const SizedBox(height:16),
            //按钮组
            Row(
              children: [
                //播放按钮
                GestureDetector(
                  onTap: (){
                    global.player.setPlayList(songlist);
                    global.player.playIndex(0);
                  },
                  child: HoverView(
                      normalColor: const Color(0xFFEC4141),
                      hoverColor: const Color(0xFFDD0000),
                      padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                      height: 34,
                      radius: 90,
                      child: Row(
                        children: [
                          const Icon(Icons.play_arrow_rounded, color: Colors.white),
                          const SizedBox(width: 2),
                          Container(width: 1, color: Colors.white70, height: 12,),
                          const SizedBox(width: 8),
                          const Text("播放全部", style: TextStyle(color: Colors.white)),
                        ],
                      )
                  ),
                ),
                //收藏按钮
                const SizedBox(width: 8),
                HoverView(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                    height: 34,
                    radius: 90,
                    child: GestureDetector(
                      onTap: () => songlist.subs(),
                      child: Obx((){
                        return Opacity(
                          opacity: (){
                            if(songlist.isBySelf()) return 0.5;
                            if(songlist.subscribed.isTrue) return 0.5;
                            return 1.0;
                          }(),
                          child: Row(
                            children: [
                              Icon((){
                                if(songlist.isBySelf()) return FeatherIcons.bookmark;
                                if(songlist.subscribed.isTrue) return FeatherIcons.bookmark;
                                return FeatherIcons.folder;
                              }(),
                                  size: 18
                              ),
                              const SizedBox(width: 8),
                              Text((){
                                if(songlist.isBySelf()) return "收藏";
                                if(songlist.subscribed.isTrue) return "已收藏";
                                return "收藏";
                              }(),
                              ),
                              const SizedBox(width: 4),
                              Text((){
                                return songlist.getBookCount();
                              }(), style: const TextStyle(color: Colors.black38))
                            ],
                          ),
                        );
                      }),
                    )
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("歌曲 : ${songlist.trackCount + songlist.cloudTrackCount}首   播放 : ${songlist.getPlayCount()}"),
            const SizedBox(height: 16),
            //简介
            ReadMoreText(
              songlist.description ?? "没有简介",
              trimLines: 1,
              trimMode: TrimMode.Line,
              trimCollapsedText: " ▽",
              trimExpandedText: "  △",
              moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        ))
      ],
    );
  }
}
