import 'package:get/get.dart';
import 'Global.dart';

class Settings extends GetxController {
  var debugMode = true.obs;                        //调试模式

  //清除所有数据重置整个应用
  void resetAPP(){
    storage.erase();
  }
}

