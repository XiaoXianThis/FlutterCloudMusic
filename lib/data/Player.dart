import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music/api/Tools.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/Song.dart';
import 'package:music/data/SongList.dart';

import '../api/http.dart';

//播放模式
enum PlayMode {
  sequential, //顺序播放
  loop,       //单曲循环
  listLoop,   //列表循环
  random,     //随机播放
}

//播放状态
enum PlayResult {
  ok,               //正常播放
  copyright,        //无版权
  error,            //播放失败
}

//播放器
class Player extends GetxController {

  var isPlaying = false.obs;                        //是否正在播放
  var song = Song("", "", "", "", SongPlatform.neteasy, json: null).obs;  //正在播放的歌曲
  var songlist = SongList(id: "0", name: "空", creatorName: "空", creatorId: "0", subscribed: false);     //播放列表
  var playMode = PlayMode.sequential.obs;          //播放模式
  final player = AudioPlayer();                     //播放器
  var progress = const Duration(seconds: 0).obs;    //当前进度
  var progressText = "00:00".obs;                   //当前进度(字符串)
  var duration = const Duration(seconds: 0).obs;    //音频时长
  var durationText = "00:00".obs;                   //音频时长(字符串)
  var volume = 1.0.obs;                             //音量

  var recentSong = <Song>[];                        //播放历史记录
  var current = 0.obs;                              //当前歌曲在歌单中的index

  Player(){
    //读取设置
    loadSettings();
    //每秒刷新进度
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      //播放中状态
      if(player.state == PlayerState.playing){
        isPlaying.value = true;
        //获取进度和总时长
        progress.value = await player.getCurrentPosition() ?? const Duration();
        duration.value = await player.getDuration() ?? const Duration();
        //转换为字符串
        progressText.value = durationToString(progress.value);
        durationText.value = durationToString(duration.value);
      }
      //播放完成状态
      else if(player.state == PlayerState.completed){
        player.stop();//切换到stop状态，防止下次更新时，又执行一次下一首
        isPlaying.value = false;
        if(songlist.songs.isNotEmpty){
          autoNext();//播放完成自动下一曲
        }
      }
      //暂停、停止 状态
      else {
        isPlaying.value = false;
      }
    });
  }

  //读取保存的设置
  void loadSettings(){
    //音量设置
    volume.value = storage.read("volume") ?? 1.0;
    player.setVolume(volume.value);
    //播放模式
    playMode.value = storage.read("playmode") ?? PlayMode.sequential;
    //重置播放器
    player.setSource(UrlSource(""));
  }

  //传入一个歌单、专辑作为播放列表
  void setPlayList(SongList songlist){
    this.songlist = songlist;
    songlist.songs.indexOf(song.value);
  }

  //播放指定ID曲目
  //如果成功播放则返回true，失败返回false
  Future<PlayResult> play(Song song) async {
    //先停止当前曲目播放
    player.stop();
    // print("播放歌曲:${song.name}, id:${song.id}");
    if(song.copyright == true){
      //获取mp3链接
      var url = await song.getUrl();
      if(url != ""){
        //切换前将当前歌曲加入历史记录
        recentSong.add(this.song.value);
        //切换歌曲
        this.song.value = song;
        await player.setSource(UrlSource(url));
        start();
        return PlayResult.ok;
      }
      else {
        var copyright = await song.check();
        if(copyright == false){
          toast("${song.name} 暂无版权。");
          return PlayResult.copyright;
        }
        logs.error("播放歌曲:${song.name}, id:${song.id}失败，没有获取到mp3链接。");
        toast("播放没有成功，因为没有获取到音频链接，换一首试试吗？");
        return PlayResult.error;
      }
    }
    //无版权
    else {
      return PlayResult.copyright;
    }
  }

  //播放歌单中指定索引的歌曲
  //如果成功播放则返回true，失败返回false
  Future<PlayResult> playIndex(int index) async {
    //---------计算下标
    //全部音乐数量 = 在线音乐数量 + 云盘音乐数量
    var trackCount = songlist.trackCount + songlist.cloudTrackCount;
    //如果index在歌单范围内
    if(index >=0 && index < trackCount){
      current.value = index;
    }
    //如果index为负数, 则从最后一首开始算起
    else if(index < 0){
      current.value = trackCount + index;
    }
    //如果index大与歌单歌曲数量, 则从头播起
    else if(index >= trackCount){
      current.value = index - trackCount;
    }

    //-----------获取歌曲并播放
    //如果songlist中已经加载了这首
    if(current.value < songlist.songs.length){
      //读取并播放
      return await play(songlist.songs[current.value]);
    }
    //如果还未加载
    else {
      //加载并播放
      var url = "$host/playlist/track/all?id=${songlist.id}&limit=1&offset=${current.value}${(){ if(global.localUser.login.isTrue) return "&cookie="+global.localUser.cookie.value; }()}";
      var json = await http_get_json(url);
      var song = jsonToSong(json["songs"][0], json["privileges"][0]);
      return await play(song);
    }
  }

  void start(){ //开始播放
    isPlaying.value = true;
    player.resume();
  }

  void pause(){ //暂停播放
    isPlaying.value = false;
    player.pause();
  }

  //下一曲
  void next() async {
    //歌单全部歌曲数量
    var trackCount = songlist.trackCount + songlist.cloudTrackCount;
    var index = 0;
    //如果随机
    if(playMode.value == PlayMode.random){
      index = Random(DateTime.now().millisecondsSinceEpoch).nextInt(trackCount);
    }
    //否则顺序播放
    else {
      index = current.value + 1;
    }
    //播放状态 (成功:PlayResult.ok)
    var status = await playIndex(index);
    if(status != PlayResult.ok){
      next();
    }
  }
  //下一曲(自动切换)
  void autoNext() async {
    //歌单全部歌曲数量
    var trackCount = songlist.trackCount + songlist.cloudTrackCount;
    var index = 0;
    //如果随机
    if(playMode.value == PlayMode.random){
      index = Random(DateTime.now().millisecondsSinceEpoch).nextInt(trackCount);
    }
    else{
      //单曲循环
      if(playMode.value == PlayMode.loop){
        play(song.value);
        return;
      }
      index = current.value + 1;
      //顺序播放,播完停止
      if(playMode.value == PlayMode.sequential && index >= trackCount){
        player.stop();
        return;
      }
      //列表循环,不用管 默认就是
    }
    //播放状态 (成功:PlayResult.ok)
    var status = await playIndex(index);
    if(status != PlayResult.ok){
      next();
    }
  }

  //上一曲
  void back() async {
    //歌单全部歌曲数量
    var trackCount = songlist.trackCount + songlist.cloudTrackCount;
    var index = 0;
    //如果随机
    if(playMode.value == PlayMode.random){
      index = Random(DateTime.now().millisecondsSinceEpoch).nextInt(trackCount);
    }
    //否则按顺序后退
    else{
      index = current.value - 1;
    }
    //播放状态 (成功:PlayResult.ok)
    var status = await playIndex(index);
    if(status != PlayResult.ok){
      back();
    }
  }

  //跳转播放进度(按百分比)
  void seek(double value){
    var seconds = (duration.value.inSeconds * value).toInt();
    var time = Duration(seconds: seconds);
    player.seek(time);
    progress.value = time;
  }

  //设置音量
  void setVolume(double volume){
    this.volume.value = volume;
    player.setVolume(volume);
    storage.write("volume", volume);
  }

  //切换播放模式
  void changePlayMode(){
    if(playMode.value == PlayMode.sequential){ playMode.value = PlayMode.listLoop; }
    else if(playMode.value == PlayMode.listLoop){ playMode.value = PlayMode.loop; }
    else if(playMode.value == PlayMode.loop){ playMode.value = PlayMode.random; }
    else if(playMode.value == PlayMode.random){ playMode.value = PlayMode.sequential; }
    storage.write("playmode", playMode.value);
  }


}

//Duration对象格式化 "00:00"
String durationToString(Duration duration){
  var str = duration.toString();
  if(duration.inSeconds >= 0){
    if(duration.inHours > 0){
      return str.substring(0, str.length-7);
    }
    else {
      return str.substring(2, str.length-7);
    }
  }
  else{
    return "00:00";
  }
}
