import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:music/data/Global.dart';


class Spotify extends GetxController {
  var login = false.obs;                           //是否登录
  var accessToken = "".obs;                        //访问接口需要带上的临时token（1小时过期）
  var _refresh_token = "";                        //刷新token需要用到的token

  Spotify(){
    init();
  }

  void init() async {
    _refresh_token =  storage.read("refresh_token") ?? "";       //尝试读取本地refresh_token
    refresh();                                                  //刷新access_token
  }

  //登录并获取refresh_token
  Future<String> getRefreshToken() async {
    //登录取得授权码
    var code = await spotifyLogin();
    //授权码获得refresh_token
    var json = await requestAccessToken(code);
    _refresh_token = json["refresh_token"];
    //保存方便下次读取
    storage.write("refresh_token", _refresh_token);
    return _refresh_token;
  }

  //刷新access_token
  void refresh() async{
    var json = await refreshAccessToken(_refresh_token);        //尝试使用本地refresh_token获取access_token
    //如果有 error, 则代表获取失败
    if(json["error"] != null) {
      //登录后再尝试获取
      await getRefreshToken();
      var json = await refreshAccessToken(_refresh_token);
      accessToken.value = json["access_token"];
    }
    //没有 error
    else { accessToken.value = json["access_token"]; }

    //_refresh_token不为空则代表已登录
    if(_refresh_token != ""){
      login.value = true;
    }
    logs.debug("access_token:${accessToken.value}");
  }


}
















// 0.创建本地服务器，接收授权码

// 1.调用浏览器打开授权网址
// https://accounts.spotify.com/authorize?response_type=code&client_id=e8cc1dc4ef6a476fa6f3867f29ee4f8c&scope=user-library-read,playlist-modify-public,playlist-modify-private&redirect_uri=http://localhost:8888/code_callback

// 2.成功后回调本地8888端口，返回授权码
// http://localhost:8888/?code=AQBaQad3fmaF_7UkvNjKmU7xDxt_UHAaeaCiPQGzTMqfoQO2qnDerS7TUqKpurEYX0rG_8Mq2rQkvgmwAtcQ_jP7xm0Gg60j9pCLlZzNMwwVp2m96oyxOCEjihVg0c0OgXdec3WA41REB6QZOLcKeAv-IoUToY1QgQb1VZ9cz8rSvqOScLRW95OL4o6B0ZChjzC6bRa86xB7TZXLYP6dg221pOOr1Ega6xMb4jTEHMaKAzgk96QDhHblpGVk

// 3.使用授权码获取token
// https://accounts.spotify.com/api/token

var clientID = "e8cc1dc4ef6a476fa6f3867f29ee4f8c";                //客户端ID, 在Spotify官网注册后可以得到 https://developer.spotify.com/dashboard/applications
var clientSecret = "039b42b8847646589807337a3798eea6";            //客户端密码
var scope = "user-library-read,playlist-modify-public,playlist-modify-private";   //全部权限
var callbackURL = "http://localhost:8888/code_callback";         //回调URL
var authorizeCodeUrl = "https://accounts.spotify.com/authorize?response_type=code&client_id=$clientID&scope=$scope&redirect_uri=$callbackURL";  //授权地址（调用浏览器打开）


//登录获取授权码
Future<String> spotifyLogin() async {
  // 1.创建回调服务器，接收授权数据
  var server = await HttpServer.bind("127.0.0.1", 8888);

  // 2.打开浏览器让用户授权登录
  var tranceUlr = authorizeCodeUrl.replaceAll("&", "^&");       // CMD需要在 & 符号前加 ^ 来转义
  await Process.run("cmd", ["/k", "start", tranceUlr]);

  // 3.监听回调服务器，获取授权码
  var authorization_code = "";
  await for(HttpRequest request in server){
    //授权码回调
    if(request.uri.path == "/code_callback"){
      var code = request.uri.queryParameters["code"];     //授权码
      var error = request.uri.queryParameters["error"];     //错误码
      if(code != null){
        request.response.headers.contentType = ContentType.html;
        request.response.write("<H2>授权成功!页面即将关闭...</H2><script>setTimeout(()=>{ window.location.href=\"about:blank\";window.close(); }, 5000);</script>");
        request.response.close();
        // 3.获取到授权码后, 就可以使用授权码获取token了
        authorization_code = code;
        break;
      }
      else if(error != null){
        request.response.write("<H2>授权失败!</H2><span>$error</span>");
        request.response.close();
        break;
      }
    }
  }
  server.close();
  return authorization_code;
}

// 3.获取token, 返回josn (获取到授权码后, 这个方法将被调用)
/*
  {
     "access_token": "NgCXRK...MzYjw",                //token
     "token_type": "Bearer",                          //类型
     "scope": "user-read-private user-read-email",    //权限
     "expires_in": 3600,                              //token过期时间（1小时）
     "refresh_token": "NgAagA...Um_SHo"               //
  }
*/
Future<dynamic> requestAccessToken(String authorization_code) async{   // code: 获取到的授权码
  var res = await http.post(
    Uri.parse("https://accounts.spotify.com/api/token"),
    headers: {
      "Authorization": "Basic ${ base64.encode( utf8.encode("$clientID:$clientSecret") ) }"
    },
    body: {
      "code": authorization_code,                       //授权码
      "redirect_uri": callbackURL,        //回调URL
      "grant_type": "authorization_code",
    },
  );
  var result = json.decode(res.body);
  return result;
}


//token过期后刷新token，需要提供refresh_token（在requestAccessToken中获取）
Future<dynamic> refreshAccessToken(String refresh_token) async {
  var res = await http.post(
    Uri.parse("https://accounts.spotify.com/api/token"),
    headers: {
      "Authorization": "Basic ${ base64.encode( utf8.encode("$clientID:$clientSecret") ) }"
    },
    body: {
      "refresh_token": refresh_token,
      "grant_type": "refresh_token",
    },
  );
  var result = json.decode(res.body);
  return result;
}

