import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/SongList.dart';
import 'package:music/ui/pages/FMPage.dart';
import 'package:music/ui/pages/HomePage.dart';
import 'package:music/ui/pages/MyMusicPage.dart';
import 'package:music/ui/pages/NavigationPage.dart';
import 'package:music/ui/pages/SongListPage.dart';
import 'HoverButton.dart';
import 'TipsImageView.dart';



class LeftSideNavigationBar extends StatefulWidget {
  const LeftSideNavigationBar({Key? key}) : super(key: key);



  @override State<LeftSideNavigationBar> createState() => _LeftSideNavigationBarState();
}

class _LeftSideNavigationBarState extends State<LeftSideNavigationBar> {
  var index = 0;
  @override Widget build(BuildContext context) {
    return DynMouseScroll(builder: (context, scrollController, physics)=>
      ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView(
        controller: scrollController,
        physics: physics,
        padding: const EdgeInsets.all(12),
        children: [
          //固定
          HoverButton(index++,
              FeatherIcons.package,
              "发现音乐",
              rightWidget: Container(child: const Text("开发中", style: TextStyle(color: Colors.white, fontSize: 12)), decoration: BoxDecoration(color: const Color(0x13000000), borderRadius: BorderRadius.circular(4)), padding: const EdgeInsets.fromLTRB(2, 0, 2, 0)),
              onTap: (){ global.navigationController.push( HomePage ); }
          ),
          HoverButton(index++,
            FeatherIcons.radio,
            "私人FM",
            rightWidget: Container(child: const Text("开发中", style: TextStyle(color: Colors.white, fontSize: 12)), decoration: BoxDecoration(color: const Color(0x13000000), borderRadius: BorderRadius.circular(4)), padding: const EdgeInsets.fromLTRB(2, 0, 2, 0)),
            onTap: () { global.navigationController.push( FMPage ); }
          ),
          HoverButton(index++, FeatherIcons.heart, "我喜欢的音乐", onTap: () {
            global.navigationController.push(MyMusicPage);
          }),
          HoverButton(
              index++,
              FeatherIcons.download, "本地与下载",
              rightWidget: Container(child: const Text("开发中", style: TextStyle(color: Colors.white, fontSize: 12)), decoration: BoxDecoration(color: const Color(0x13000000), borderRadius: BorderRadius.circular(4)), padding: const EdgeInsets.fromLTRB(2, 0, 2, 0)),
          ),
          HoverButton(
              index++,
              FeatherIcons.clock, "最近播放",
            rightWidget: Container(child: const Text("开发中", style: TextStyle(color: Colors.white, fontSize: 12)), decoration: BoxDecoration(color: const Color(0x13000000), borderRadius: BorderRadius.circular(4)), padding: const EdgeInsets.fromLTRB(2, 0, 2, 0)),
          ),


          //创建的歌单
          Obx((){
            return ExpansionTile(
              initiallyExpanded: true,
              tilePadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              title: const Text("创建的歌单", style: TextStyle(fontSize: 14, color: Colors.black38)),
              children: ((){
                List<Widget> result = [];
                for (var item in global.localUser.songLists) {
                  item = (item as SongList);
                  result.add(
                    GestureDetector(
                      onTap: ()=>global.navigationController.push(SongListPage(
                          songlist: item,
                          key: ValueKey("歌单:${item.id}"),
                      )),
                      child: HoverButton(index++, FeatherIcons.barChart2, item.name),
                    )
                  );
                }
                return result;
              }()),
            );
          }),

          //收藏的歌单
          Obx((){
            return ExpansionTile(
              initiallyExpanded: true,
              tilePadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              title: const Text("收藏的歌单", style: TextStyle(fontSize: 14, color: Colors.black38)),
              children: ((){
                List<Widget> result = [];
                for (var item in global.localUser.favoriteSongLists) {
                  item = (item as SongList);
                  result.add(GestureDetector(
                      onTap: () {
                        global.navigationController.push(SongListPage(
                            songlist: item,
                            key: ValueKey("歌单:${item.id}"),
                        ));
                      },
                      child: HoverButton(index++, FeatherIcons.barChart2, item.name)
                  ));
                }
                return result;
              }()),
            );
          }),

        ],
      ),
    ));
  }
}




