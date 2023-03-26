import 'dart:io';
import 'package:get/get.dart';
import 'package:music/api/http.dart';
import 'package:music/data/Global.dart';

enum SongPlatform {
  neteasy,    //网易云
  spotify     //spotify
}

//歌曲
class Song extends GetxController{
  String name = "";                                   //歌曲名称
  String artists = "";                                //歌手
  String album = "";                                  //专辑名称
  SongPlatform platform = SongPlatform.neteasy;       //来源平台
  String id = "";                                     //歌曲ID
  String? picUrl;                                  //封面URL
  dynamic json;                                     //传入json
  var copyright = true;                           //是否有版权
  var couldDriver = false;                        //是来自云盘
  var isLike = false.obs;                           //是否是喜欢的音乐

  Song(this.id, this.name, this.artists, this.album, this.platform, { this.picUrl="", required this.json, this.copyright = true, this.couldDriver = false });

  //检查音乐是否有版权
  Future<bool> check() async {
    var copyrightJson = await http_get_json("$host/check/music?id=$id&br=128000${((){ if(global.localUser.login.value) {return "&cookie=${global.localUser.cookie}";} else {return "";}}())}");
    copyright = copyrightJson["success"] as bool;
    return copyright;
  }

  //根据 来源平台 和 ID 获取歌曲链接
  Future<String> getUrl() async {
    if(platform == SongPlatform.neteasy){
      //{"data":[{"id":2016442586,"url":"http://m701.music.126.net/20230316130347/55d14cbe0d5e775a31ebcdd0ff3d7930/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/24203557843/ec66/620e/d099/232969b98a5457dcfca2f384a04b3bd5.mp3","br":320000,"size":7347885,"md5":"232969b98a5457dcfca2f384a04b3bd5","code":200,"expi":1200,"type":"mp3","gain":-9.2584,"peak":1,"fee":8,"uf":null,"payed":1,"flag":260,"canExtend":false,"freeTrialInfo":null,"level":"exhigh","encodeType":"mp3","freeTrialPrivilege":{"resConsumable":false,"userConsumable":false,"listenType":null,"cannotListenReason":null},"freeTimeTrialPrivilege":{"resConsumable":false,"userConsumable":false,"type":0,"remainTime":0},"urlSource":0,"rightSource":0,"podcastCtrp":null,"effectTypes":null,"time":183672}],"code":200}
      var json = await http_get_json("$host/song/url?id=${id}${((){ if(global.localUser.login.value) {return "&cookie=${global.localUser.cookie}";} else {return "";}}())}");
      var url = json["data"][0]["url"];
      return url ?? "";
    }
    else if(platform == SongPlatform.spotify){

    }
    return "";
  }
  //把这首歌 加入/移除 喜欢的音乐
  void like() async {
    if(id!=""){
      //登录后才可以收藏
      if(global.localUser.login.isTrue){
        //"我喜欢"歌单
        var likeSongList = global.localUser.songLists[0];
        //如果未喜欢
        if(!isLike.value){
          //添加到"我喜欢"歌单
          if(await likeSongList.addSong(this)){
            isLike.value = !isLike.value;
            global.localUser.likeSons.add(int.parse(id));
          }
        }
        else {
          //从我喜欢中移除
          if(await likeSongList.removeSong(this)){
            isLike.value = !isLike.value;
            global.localUser.likeSons.remove(int.parse(id));
          }
        }
      }
    }
  }

  //检查音乐是否在喜欢列表中
  void checkLike(){
    if(global.localUser.login.isTrue && id!=""){
      isLike.value = global.localUser.likeSons.contains(int.parse(id));
    }
  }

  //下载这首歌
  void download() async {
    var url = await getUrl();
    Process.run('cmd', ['/c', 'start', url]);
  }

  get getPicUrl {
    if(picUrl != ""){
      return picUrl;
    }
    else {
      return "";
    }
  }
}


// 搜索时 privilege 保存在 songItem 中, privilege 可以传null
// 但是歌单的 privilege 是单独保存, 如果是单独保存的，就要传入 privilege
Song jsonToSong(dynamic songItem, dynamic privilegeItem){
  // print(jsonEncode(songItem));
  // print(jsonEncode(privilegesItem));
  // print("\n\n");
  var song = Song(
      "${songItem["id"]}",
      songItem["name"],
      (() {
        var result = "";
        List<dynamic> artists = songItem["ar"];
        if(artists.isNotEmpty) {
          for (var item in artists) {
            var name = item["name"];
            if(name != null){
              result += "$name/";
            }
            else {
              result += "未知歌手/";
            }
          }
          result = result.substring(0, result.length - 1);
        }
        return result;
      }()),
          (){
        if(songItem["al"] != null&& songItem["al"]["name"]!=null){
          return songItem["al"]["name"];
        } else {
          return "未知专辑";
        }
      }(),
      SongPlatform.neteasy,
      picUrl: songItem["al"]["picUrl"],
      json: songItem,
      //版权信息
      copyright: (){
        if(privilegeItem != null){
          if(privilegeItem["st"] == -200 ){ return false; } else { return true; }
        }
        else if(songItem["privilege"]!=null){
          if(songItem["privilege"]["st"] == -200 ){ return false; } else { return true; }
        }
        return true;
      }(),
      //是否云盘
      couldDriver: (){
        if(privilegeItem != null){
          return privilegeItem["cs"]??false;
        }
        else if(songItem["privilege"]!=null){
          return songItem["privilege"]["cs"]??false;
        }
        return false;
      }()
  );
  song.checkLike();
  return song;
}