import 'package:get/get.dart';
import 'package:music/api/http.dart';
import 'package:music/data/Global.dart';
import 'package:music/data/SongList.dart';
import 'package:music/ui/widget/VipLogo.dart';


//(登录)用户数据
class LocalUser extends GetxController {
  var cookie = "".obs;             //用户登录后cookie
  var login = false.obs;            //是否已登录
  var name = "".obs;                //用户昵称
  var signature = "".obs;           //用户个性签名
  var follows = 0.obs;              //关注数
  var followeds = 0.obs;           //粉丝数
  var avatarUrl = "".obs;           //用户头像
  var backgroundUrl = "".obs;       //背景图片
  var id = "0".obs;                 //用户ID
  var vipType = VipType.none.obs;   //会员类型
  var level = "0".obs;              //等级
  var songLists = <SongList>[].obs;           //创建的歌单
  var favoriteSongLists = [].obs;   //收藏的歌单
  var listenSongs = 0.obs;          //听过音乐的数量
  var likeSons = <int>[].obs;       //"我喜欢的音乐"中所有歌曲ID，用来判断音乐是否已经点了红心

  LocalUser() {
    refresh();
  }


  //刷新登录
  void refresh() async{
    cookie.value = storage.read("cookie") ?? "";
    //未登录: {"code":200,"account":{"id":8023474819,"userName":"0_m15849353741@163.com","type":0,"status":-10,"whitelistAuthority":0,"createTime":1662826838020,"tokenVersion":0,"ban":0,"baoyueVersion":0,"donateVersion":0,"vipType":0,"anonimousUser":false,"paidFee":false},"profile":null}
    //已登录： {"code":200,"account":{"id":125279114,"userName":"1_********642","type":1,"status":0,"whitelistAuthority":0,"createTime":1457687184915,"tokenVersion":2,"ban":0,"baoyueVersion":-2,"donateVersion":0,"vipType":10,"anonimousUser":false,"paidFee":false},"profile":{"userId":125279114,"userType":0,"nickname":"大不6仙","avatarImgId":18790653720730010,"avatarUrl":"http://p2.music.126.net/JGqIsiaIxBPV_I31bKcfOQ==/18790653720730009.jpg","backgroundImgId":109951165537466530,"backgroundUrl":"http://p1.music.126.net/AxzmxlUMQ9DRBR8Ls8b8og==/109951165537466524.jpg","signature":"永远当一只小白熊，多好，哔哩哔哩UP主@大不6仙","createTime":1457687202040,"userName":"1_********642","accountType":1,"shortUserName":"********642","birthday":-2209017600000,"authority":0,"gender":0,"accountStatus":0,"province":440000,"city":440100,"authStatus":0,"description":null,"detailDescription":null,"defaultAvatar":false,"expertTags":null,"experts":null,"djStatus":0,"locationStatus":30,"vipType":10,"followed":false,"mutual":false,"authenticated":false,"lastLoginTime":1678677353081,"lastLoginIP":"::1","remarkName":null,"viptypeVersion":1677920559192,"authenticationTypes":0,"avatarDetail":null,"anchor":false}}
    var json = await http_get_json("$host/user/account?cookie=${Uri.encodeComponent(cookie.value)}");
    var profile = json["profile"];

    //如果profile不为空，则表示已登录
    if(profile!=null){
      //获取用户详情信息
      var detail = await http_get_json("$host/user/detail?uid=${json["profile"]["userId"]}");
      login.value = true;
      name.value = profile["nickname"];
      signature.value = profile["signature"];
      avatarUrl.value = profile["avatarUrl"];
      backgroundUrl.value = profile["backgroundUrl"];
      id.value = "${profile["userId"]}";
      vipType.value = ((){
        int vipCode = profile["vipType"];
        //10是畅听会员
        if(vipCode == 10){
          global.vipLogoController.vipType.value = VipType.vip;
          return VipType.vip;
        }
        //11是黑胶CVIP
        else if(vipCode == 11){
          global.vipLogoController.vipType.value = VipType.cvip;
          return VipType.cvip;
        }
        else {
          global.vipLogoController.vipType.value = VipType.none;
          return VipType.none;
        }
      }());
      level.value = "${detail["level"]}";
      listenSongs.value = detail["listenSongs"];
      follows.value = detail["profile"]["follows"];
      followeds.value = detail["profile"]["followeds"];

      //结果示例： {full: false, data: {userId: 125279114, info: 60G音乐云盘免费容量$黑名单上限120$云音乐商城满100减12元优惠券$价值1200云贝, progress: 0.13508333333333333, nextPlayCount: 12000, nextLoginCount: 350, nowPlayCount: 1621, nowLoginCount: 350, level: 9}, code: 200}
      // var levelJson = await http_get_json("$host/user/level?cookie=${Uri.encodeComponent(cookie.value)}");
      // level.value = "${levelJson["data"]["level"]}";


      // 获取用户歌单数量
      // {programCount: 0, djRadioCount: 1, mvCount: 10, artistCount: 36, newProgramCount: 0, createDjRadioCount: 0, createdPlaylistCount: 18, subPlaylistCount: 78, code: 200}
      var subcount = await http_get_json("$host/user/subcount?cookie=${Uri.encodeComponent(cookie.value)}");
      var playListCount = subcount['createdPlaylistCount'] + subcount['subPlaylistCount'];
      //获取用户歌单
      List<dynamic> playlist = [];
      for(var i = 0; i<playListCount; i+=50){
        var playlistJson = await http_get_json("$host/user/playlist?uid=${id.value}&limit=50&offset=${i}${ (){ if(login.isTrue) {return "&&cookie=${cookie.value}";}else{return "";} }() }");
        playlist.addAll(playlistJson["playlist"]);
      }

      jsonToSongLists(playlist).forEach((playlist) {
        //如果歌单创建者ID和用户吻合
        if(playlist.creatorId == id.value) {
          songLists.add(playlist);
        } else {
          favoriteSongLists.add(playlist);
        }
      });

      //全部喜欢歌曲的ID []
      var url = "$host/likelist?uid=${id.value}&cookie=$cookie";
      json = await http_get_json(url);
      if(json["code"]==200){
        List<dynamic> ids = json["ids"];
        List<int> temp = [];
        for (var element in ids) {
          temp.add(element);
        }
        likeSons.value = temp;
      }
    }
  }

  void logout() async {
    await http_get_json("$host/logout?cookie=${Uri.encodeComponent(global.localUser.cookie.value)}");
    global.localUser.login.value = false;
    global.localUser.cookie.value = "";
    storage.remove("cookie");
    global.vipLogoController.vipType.value = VipType.none;
    //重置属性
    cookie.value = "";             //用户登录后cookie
    login.value = false;            //是否已登录
    name.value = "";                //用户昵称
    signature.value = "";           //用户个性签名
    follows.value = 0;              //关注数
    followeds.value = 0;           //粉丝数
    avatarUrl.value = "";           //用户头像
    backgroundUrl.value = "";       //背景图片
    id.value = "0";                 //用户ID
    vipType.value = VipType.none;   //会员类型
    level.value = "0";              //等级
    songLists.value = [];           //创建的歌单
    favoriteSongLists.value = []; //收藏的歌单
    listenSongs.value = 0;          //听过音乐的数量
    likeSons.clear();
  }

}
