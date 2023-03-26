import 'dart:async';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/api/http.dart';
import 'package:music/data/Global.dart';
import 'package:music/ui/pages/SearchPage/AlbumSearch.dart';
import 'package:music/ui/pages/SearchPage/ArtistSearch.dart';
import 'package:music/ui/pages/SearchPage/SpotifySearch.dart';
import 'package:music/ui/pages/SearchPage/SongListSearch.dart';
import 'package:music/ui/pages/SearchPage/UserSearch.dart';
import 'package:music/ui/widget/SearchTabBar.dart';
import 'SingleSearch.dart';

//搜索类型
class SearchType {
  static const int song = 1;          //单曲
  static const int album = 10;        //专辑
  static const int artist = 100;      //歌手
  static const int playlist = 1000;   //歌单
  static const int user = 1002;       //用户
  static const int spotify = -1;       //spotify平台


  static const Map<int, int> keymap = {
    0: song,
    1: album,
    2: artist,
    3: playlist,
    4: user,
    5: spotify,
  };       //spotify平台
}
//控制器
class SearchPageController extends GetxController {
  int limit = 80;                               //每页结果数量
  var searchType = SearchType.song.obs;         //搜索类型
  var offset = 0.obs;                           //分页
  var json = {}.obs;                            //根据json绘制界面, 更新json则更新界面

  //搜索, 传入关键字, 第几页
  Future<void> search(String keyword) async {
    //搜网易云
    if(searchType.value > 0){
      // print("$host/search?keywords=${Uri.encodeComponent(keyword)}&limit=$limit&offset=${offset*limit}&type=$searchType");
      json.value = await http_get_json("$host/cloudsearch?keywords=${Uri.encodeComponent(keyword)}&limit=$limit&offset=${offset*limit}&type=${searchType.value}${(){
        if(global.localUser.login.value == true) { return "&cookie=${global.localUser.cookie}"; }
        else { return ""; }
      }()}");
    }
    //搜spotify
    else if(searchType.value == SearchType.spotify){
      // json.value = await http_get_json("https://api.spotify.com/v1/search?q=${Uri.encodeComponent(keyword)}&type=track&limit=50", headers: {
      //   "Authorization": "Bearer ${global.spotify.accessToken.value}",
      //   "Content-Type": "application/json"
      // });
    }
  }
}
//搜索页面
class SearchPage extends StatelessWidget {
  SearchPage({required Key key, required this.keyword}) : super(key: key);

  final String keyword;
  final SearchPageController controller = SearchPageController();

  @override
  Widget build(BuildContext context) {
    return DynMouseScroll(
      builder: (context, scrollController, physics) => ListView(
        shrinkWrap: true,
        controller: scrollController,
        physics: physics,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 50),
        children: [
          Column(
            children: [
              //标题文字
              Row(children: [Text("搜索 $keyword", style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),],),
              const SizedBox(height: 20),
              //TabBar
              SearchTabBar(tabs:const ["单曲", "专辑", "歌手", "歌单", "用户"] , extendTabs: const [], callback: () async {
                //判断切换的tab, 设置获取多少条目
                switch(controller.searchType.value){
                  case SearchType.song:  controller.limit = 100;  break;
                  case SearchType.album: controller.limit = 15;  break;
                  case SearchType.artist:  controller.limit = 10;  break;
                  case SearchType.playlist:  controller.limit = 20;  break;
                  case SearchType.user: controller.limit = 15;  break;
                  case SearchType.spotify: controller.limit = 80;  break;
                }
                //再刷新搜索结果json，顺序不能错
                await controller.search(keyword);
              }, controller: controller ),
            ],
          ),
          const SizedBox(height: 20),
          Obx((){
            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Column(
                children: buildSearchWidgets(controller, keyword),
              ),
            );
          }),
        ],
      ),
    );
  }
}

//根据controller中的搜索类型，动态构建搜索结果ListView内容
List<Widget> buildSearchWidgets(SearchPageController controller, String keyword) {
  //切换tab时刷新搜索
  // controller.search(keyword);
  // print("build widget");
  if(controller.searchType.value == SearchType.song) {
    return buildSingleSearchWidgets(controller, keyword);
  }
  else if(controller.searchType.value == SearchType.album) {
    return buildAlbumSearchWidgets(controller, keyword);
  }
  else if(controller.searchType.value == SearchType.artist) {
    return buildArtistSearchWidgets(controller, keyword);
  }
  else if(controller.searchType.value == SearchType.playlist) {
    return buildSongListSearchWidgets(controller, keyword);
  }
  else if(controller.searchType.value == SearchType.user) {
    return buildUserSearchWidgets(controller, keyword);
  }
  else if(controller.searchType.value == SearchType.spotify) {
    return buildSpotifySearchWidgets(controller, keyword);
  }
  return buildSingleSearchWidgets(controller, keyword);
}



