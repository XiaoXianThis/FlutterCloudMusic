
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//会员类型
enum VipType {
  none,   //非会员
  vip,    //畅听会员
  cvip,   //黑胶VIP
  svip,   //黑胶SVIP
}

class VipLogoController extends GetxController {
  //会员类型
  var vipType = VipType.none.obs;
}

enum VipLogoSize {
  normal,     //正常小尺寸
  M,          //中等尺寸
}

class VipLogo extends StatelessWidget {
  const VipLogo({Key? key, this.size = VipLogoSize.normal}) : super(key: key);

  final VipLogoSize size;

  @override Widget build(BuildContext context) {
    //找到控制器
    VipLogoController controller = Get.find();
    return Obx((){
      return Container(
        height: (){
          switch(size){
            case VipLogoSize.normal: return 18.0;
            case VipLogoSize.M: return 22.0;
          }
        }(),
        decoration: BoxDecoration(
            color: Color(((){
              if(controller.vipType.value == VipType.vip) {
                return 0xFFFF4545;
              } else if(controller.vipType.value == VipType.cvip) {
                return 0xFF332B2B;
              } else if(controller.vipType.value == VipType.svip) {
                return 0xFF383232;
              } else {
                return 0xFFCCCCCC;
              }
            }())),
            borderRadius: BorderRadius.circular(90)
        ),
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 1),
        child: Center(
          child: Text(
            ((){
              if(controller.vipType.value == VipType.vip) {
                return "畅听VIP";
              } else if(controller.vipType.value == VipType.cvip) {
                return "黑椒CVIP";
              } else if(controller.vipType.value == VipType.svip) {
                return "黑椒SVIP";
              } else {
                return "VIP";
              }
            }()),
            style: TextStyle(
                color: Color(((){
                  if(controller.vipType.value == VipType.vip) {
                    return 0xFFFFFFFF;
                  } else if(controller.vipType.value == VipType.cvip) {
                    return 0xFFFFE2DE;
                  } else if(controller.vipType.value == VipType.svip) {
                    return 0xFFEED09E;
                  } else {
                    return 0xFFFFFFFF;
                  }
                }())),
                fontSize: (){
                  switch(size){
                    case VipLogoSize.normal: return 10.0;
                    case VipLogoSize.M: return 12.0;
                  }
                }(), textBaseline: TextBaseline.alphabetic),
          ),
        ), // (function(){}())
      );
    });
  }

}

//
// class VipLogo extends StatefulWidget {
//   VipLogo({Key? key, this.vipType = VipType.none}) : super(key: key);
//
//   VipType vipType = VipType.none;
//
//   @override
//   State<VipLogo> createState() => _VipLogoState();
// }
//
// class _VipLogoState extends State<VipLogo> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 18,
//       decoration: BoxDecoration(
//           color: Color(((){
//             if(widget.vipType == VipType.vip) {
//               return 0xFFFF4545;
//             } else if(widget.vipType == VipType.cvip) {
//               return 0xFF332B2B;
//             } else if(widget.vipType == VipType.svip) {
//               return 0xFF383232;
//             } else {
//               return 0xFFCCCCCC;
//             }
//           }())),
//           borderRadius: BorderRadius.circular(90)
//       ),
//       padding: EdgeInsets.fromLTRB(4, 0, 4, 1),
//       child: Center(
//         child: Text(
//           ((){
//             if(widget.vipType == VipType.vip) {
//               return "畅听VIP";
//             } else if(widget.vipType == VipType.cvip) {
//               return "黑椒CVIP";
//             } else if(widget.vipType == VipType.svip) {
//               return "黑椒SVIP";
//             } else {
//               return "VIP";
//             }
//           }()),
//           style: TextStyle(
//               color: Color(((){
//                 if(widget.vipType == VipType.vip) {
//                   return 0xFFFFFFFF;
//                 } else if(widget.vipType == VipType.cvip) {
//                   return 0xFFFFE2DE;
//                 } else if(widget.vipType == VipType.svip) {
//                   return 0xFFEED09E;
//                 } else {
//                   return 0xFFFFFFFF;
//                 }
//               }())),
//               fontSize: 10, textBaseline: TextBaseline.alphabetic),
//         ),
//       ), // (function(){}())
//     );
//   }
// }
//
