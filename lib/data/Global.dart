
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music/api/Spotify.dart';
import 'package:music/data/Player.dart';
import 'package:music/data/LocalUser.dart';
import 'package:music/data/Settings.dart';
import 'package:music/ui/pages/LogsPage.dart';
import 'package:music/ui/widget/QRCode.dart';
import 'package:music/ui/widget/VipLogo.dart';

import '../ui/widget/NavigationContainer.dart';

GlobalClass global = GlobalClass();           //全局变量
GetStorage storage = GetStorage();            //初始化存储
LogsController logs = LogsController();       //日志工具

class GlobalClass {

  //初始化状态
  var localUser = Get.put(LocalUser());
  var vipLogoController = Get.put(VipLogoController());
  var qrcodeController = Get.put(QRCodeController());
  var navigationController = Get.put(NavigationController());
  var player = Get.put(Player());
  var settings = Get.put(Settings());
  // var spotify = Get.put(Spotify());
}



