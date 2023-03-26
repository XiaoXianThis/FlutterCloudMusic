import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:music/api/http.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/Song.dart';

import '../api/Tools.dart';


//歌单
class SongList extends GetxController{
  var id = "0";                 //歌单ID
  var name = "0";               //歌单名称
  var creatorName = "0";        //创建者ID
  var creatorId = "0";          //创建者ID
  var coverImgUrl = "";         //封面图片
  String? description = "";         //介绍
  var playCount = 0;            //播放量
  var trackCount = 0;           //音乐数量
  var cloudTrackCount = 0;           //歌单中包含云盘音乐的数量
  int? bookCount = 0;             //收藏数量
  var songs = <Song>[].obs;        //全部歌曲
  var subscribed = false.obs;     //是否收藏了此歌单

  SongList(
      {
        required this.id,
        required this.name,
        required this.creatorName,
        required this.creatorId,
        bool subscribed = false,
        this.coverImgUrl = "",
        this.description = "",
        this.playCount = 0,
        this.trackCount = 0,
        this.bookCount = 0,
        this.cloudTrackCount = 0,
      }
  ){
    this.subscribed.value = subscribed;
  }
  get getCoverImgUrl {
    return coverImgUrl;
  }

  get getSongs {
    return songs;
  }

  //收藏/取消收藏歌单
  void subs() async {
    toast("您无需收藏自己的歌单。");
    if(!isBySelf()){
      var json = await http_get_json("$host/playlist/subscribe?t=${(){
        if(subscribed.isTrue){ return 2;} else {return 1;}    //1收藏，2取消
      }()}&id=$id${((){ if(global.localUser.login.value) {return "&cookie=${global.localUser.cookie}";} else {return "";}}())}&timestamp=${DateTime.now().millisecondsSinceEpoch}");
      if(json["code"]==200){
        subscribed.value = !subscribed.value;
      }
    } else {

    }
  }

  //从列表中移除一首音乐
  Future<bool> removeSong(Song song) async {
    var json = await http_get_json("$host/playlist/tracks?op=del&pid=$id&tracks=${song.id}${((){ if(global.localUser.login.value) {return "&cookie=${global.localUser.cookie}";} else {return "";}}())}");
    if(json["status"]==200){
      for (var item in songs) {
        if(song.id == item.id){
          songs.remove(item);
          break;
        }
      }
      songs.refresh();
      return true;
    }
    return false;
  }
  //添加一首音乐到列表中
  Future<bool> addSong(Song song) async {
    var json = await http_get_json("$host/playlist/tracks?op=add&pid=$id&tracks=${song.id}${((){ if(global.localUser.login.value) {return "&cookie=${global.localUser.cookie}";} else {return "";}}())}");
    if(json["status"]==200){
      songs.insert(0, song);
      songs.refresh();
      return true;
    }
    return false;
  }

  //歌单播放量
  String getPlayCount(){
    return parseCount(playCount);
  }

  //歌单收藏量
  String getBookCount(){
    return parseCount(bookCount ?? 0);
  }

  //判断这个是否是用户自己创建的歌单
  bool isBySelf(){
    return creatorId == global.localUser.id.value;
  }

  //每次加载300首
  Timer timer = Timer(const Duration(milliseconds: 1), (){});
  Future<void> loadMore() async {
    //防止频繁请求, 每1秒最多请求1次
    //上一个定时器结束后, 才会发出请求
    if(!timer.isActive){
      //重置定时器
      timer = Timer(const Duration(seconds: 1),(){});

      var offset = songs.length;      //偏移量
      if(offset < trackCount){
        var url = "$host/playlist/track/all?id=$id&limit=300&offset=$offset${(){ if(global.localUser.login.isTrue) return "&cookie="+global.localUser.cookie.value; }()}";
        var json = await http_get_json(url);
        List<Song> buffer = [];

        if(json["songs"] != null && json["privileges"] !=null ){
          List<dynamic> songsJson = json["songs"];              //歌曲列表
          List<dynamic> privilegesJson = json["privileges"];    //和歌曲列表一一对应，保存了歌曲周边信息（有无版权、是否来自云盘等）
          //解析song并加入列表
          for(var i=0; i<songsJson.length; i++){
            var songItem = songsJson[i];
            var privilegesItem = privilegesJson[i];
            Song song = jsonToSong(songItem, privilegesItem);
            buffer.add(song);
          }
          // for (var item in songsJson) {
          //   Song song = jsonToSong(item, );
          //   buffer.add(song);
          // }
        }
        songs.addAll(buffer);
      }
    }
  }

}


//
List<SongList> jsonToSongLists(dynamic json){
  List<SongList> result = [];
  List<dynamic> songlist = json;
  for (var item in songlist) {
    // print(jsonEncode(item));
    // print("\n\n");
    var songlist = SongList(
      id: "${item["id"]}",
      name: item["name"],
      creatorName: item["creator"]["nickname"],
      creatorId: "${item["userId"]}",
      coverImgUrl: item["coverImgUrl"],
      description: item["description"],
      playCount: item["playCount"],
      trackCount: item["trackCount"],
      cloudTrackCount: item["cloudTrackCount"] ?? 0,
      bookCount: (){
        var subscribedCount = item["subscribedCount"];
        var bookCount = item["bookCount"];
        if(subscribedCount != null) { return subscribedCount; }
        else { return bookCount; }
      }(),
      subscribed: item["subscribed"],
    );
    result.add(songlist);
  }
  return result;
}


