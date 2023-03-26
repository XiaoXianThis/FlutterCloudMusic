import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:music/api/http.dart';

import '../data/Global.dart';



//生成二维码key
Future<String> login_qrkey() async {
  var json = await http_get_json("$host/login/qr/key?timestamp=${DateTime.now().millisecondsSinceEpoch}");
  var key = json["data"]["unikey"];
  return key;
}

//根据key获取登录二维码
//返回一个二进制，可使用Image.memory()来显示
Future<Uint8List> login_qrcode(String qrkey) async {
  var json = await http_get_json("$host/login/qr/create?key=$qrkey&qrimg=true&timestamp=${DateTime.now().millisecondsSinceEpoch}");
  String qrimg = json["data"]["qrimg"];
  qrimg = qrimg.replaceFirst("data:image/png;base64,", "");
  return base64.decode(qrimg);
}

//检查登录状态
//轮询此接口可获取二维码扫码状态,800 为二维码过期,801 为等待扫码,802 为待确认,803 为授权登录成功(803 状态码下会返回 cookies)
Future<dynamic> login_check(String qrkey) async {
  // {code: 801, message: 等待扫码, cookie: }  //(803 状态码下会返回 cookies)
  var json = await http_get_json("$host/login/qr/check?key=$qrkey&timestamp=${DateTime.now().millisecondsSinceEpoch}");
  return json;
}

void logout(){
  global.localUser.logout();
}
