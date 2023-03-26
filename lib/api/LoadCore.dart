import 'dart:convert';
import 'dart:io';

import 'package:music/api/http.dart';
import 'package:music/data/Global.dart';


// NeteasyCloudMusicApi 进程
Process? core;
//启动 NeteasyCloudMusicApi
void loadCore() async {
  Process.runSync("taskkill", ["/f", "/im", "api.exe"]);
  // 创建一个可修改的环境变量
  var env = Map<String, String>.from(Platform.environment);
  // 设置端口
  env['PORT'] = "$port";
  //传入环境变量并且启动
  core = await Process.start("./api.exe", [], environment: env);
  core?.stdout.listen((event) {
    logs.debug("api.exe日志:\n ${const Utf8Codec().decode(event)}");
  });
  core?.stderr.listen((event) {
    logs.error("api.exe出现错误:\n ${const Utf8Codec().decode(event)}");
  });
}

//关闭 NeteasyCloudMusicApi
void closeCore(){
  core?.kill();
}