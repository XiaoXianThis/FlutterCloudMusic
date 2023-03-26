import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// RichText buildHeightLightText(String text, List<String> keyword){
//   return RichText(
//     text: TextSpan(
//       children: [
//
//       ]
//     ),
//   );
// }

//支持关键字高亮的Text组件
class HeightLightText extends StatelessWidget {
  HeightLightText({
    Key? key,
    required this.text,
    required this.keyword,
    this.color = 0xFF333333,
    this.heightLightColor = 0xFF507DAF,
  }) : super(key: key);

  final String text;                  //全部文字
  final String keyword;               //要高亮的关键字
  final int color;                 //文字颜色
  final int heightLightColor;      //高亮颜色

  @override
  Widget build(BuildContext context) {
    List<TextSpan> allSpan = [];
    //分割
    var split = text.split(keyword);
    if(keyword!=""){
      for (var item in split) {
        if(item != "") allSpan.add(TextSpan(text: item, style: TextStyle(color: Color(color))));
        allSpan.add(TextSpan(text: keyword, style: TextStyle(color: Color(heightLightColor))));
      }
      allSpan.removeLast();
    } else {
      allSpan.add(TextSpan(text: text, style: TextStyle(color: Color(color))));
    }
    return RichText(
      text: TextSpan(
        children: allSpan,
        style: const TextStyle(fontFamily: "HarmonyOSSans")
      ),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
    );
  }
}



