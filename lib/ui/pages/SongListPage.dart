import 'dart:async';

import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/api/Tools.dart';
import 'package:music/data/SongList.dart';
import 'package:music/ui/widget/SongItem.dart';
import 'package:music/ui/widget/SongListHeader.dart';

import '../../data/Global.dart';

class SongListPage extends StatelessWidget {
  const SongListPage({required Key key, required this.songlist}) : super(key: key);

  final SongList songlist;

  @override Widget build(BuildContext context) {
    //获取歌单歌曲详情
    if(songlist.songs.isEmpty) {
      songlist.loadMore();
    }
    return DynMouseScroll(
      builder: (ctx, scrollController, physics){
        return Obx((){
          return CustomScrollView(
            controller: scrollController,
            physics: physics,
            slivers: [
              SliverPadding(padding: const EdgeInsets.fromLTRB(30, 24, 30, 30),
                sliver: SliverToBoxAdapter(
                  child: SongListHeader(songlist: songlist),
                ),
              ),
              SliverPadding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    var song = songlist.songs[index];
                    //当创建到最后一项，则加载更多
                    if(index >= songlist.songs.length-1){
                      songlist.loadMore();
                      // print("load: index:$index;  len:${songlist.songs.length-1}");
                    }
                    return GestureDetector(
                        onDoubleTap: () {
                          //如果有版权
                          if(song.copyright == true){
                            //先将当前歌单设置为播放列表
                            global.player.setPlayList(songlist);
                            //双击播放
                            global.player.playIndex(index);
                          }
                          else {
                            toast("${song.name} 暂无版权。");
                          }
                        },
                        child: SongItem(song: song, index: index)
                    );
                  }, childCount: songlist.songs.length),
                ),
              ),

              //加载提示
              SliverPadding(padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (){
                      List<Widget> widgets = [];
                      var textStyle = const TextStyle(color: Color(0xFFAAAAAA));
                      if(songlist.trackCount == 0){
                        widgets.add(Text("空荡荡 Σ_(꒪ཀ꒪」∠)_", style: textStyle));
                      }
                      else if (songlist.songs.length >= songlist.trackCount){
                        if(songlist.trackCount < 6){
                          widgets.add(Text("", style: textStyle));
                        }
                        else {
                          widgets.add(Text("${ (){ if(songlist.cloudTrackCount>0) {return "有${songlist.cloudTrackCount}首来自☁️我的云盘，仅自己可见\n\n";} else {return "";}}() }╮(￣▽￣)╭ 没有更多了~", style: textStyle, textAlign: TextAlign.center));
                        }
                      }
                      else {
                        // widgets.add(const CupertinoActivityIndicator());
                        // widgets.add(const SizedBox(width: 8));
                        widgets.add(Text("正在加载...", style: textStyle));
                      }
                      return widgets;
                    }(),
                  ),
                ),
              )
            ],
          );
        });
      },
      // animationCurve: Curves.decelerate,
      // flickAnimationCurve: Curves.linear,

    );
  }
}

