import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music/data/User.dart';
import 'package:music/ui/pages/SearchPage/SearchPage.dart';
import 'package:music/ui/widget/HeightLightText.dart';
import 'package:music/ui/widget/HoverView.dart';



//用户搜索页面
List<Widget> buildUserSearchWidgets(SearchPageController controller, String keyword) {
  //列表项
  List<Widget> widgets = [];
  //读取json
  var result = controller.json["result"];
  // print(json.encode(result));
  if(result != null && result["userprofiles"]!=null){
    jsonToUsers(result["userprofiles"]).forEach((user) {
      widgets.add(
          HoverView(
              // normalColor: (){ if(i%2==0){ return const Color(0xFFFAFAFA); } }(),
              height: 85,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  //封面
                  SizedBox(
                      width: 60, height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                            user.getAvatarUrl + "?param=60y60",
                            errorBuilder: (context, error, stack){
                              return Image.asset("src/images/default_avatar.png");
                            }
                        ),
                      )
                  ),
                  const SizedBox(width: 20),
                  //专辑名称
                  Expanded(
                    child: HeightLightText(text: user.nickname, keyword: keyword),
                  ),
                  Expanded(
                    child: Text(user.getSignature.replaceAll("\n", " "), softWrap: false, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA))),
                  ),
                ],
              )
          )
      );
    });
  }
  return widgets;
}

List<User> jsonToUsers(dynamic json) {
  List<User> result = [];
  List<dynamic> users = json;
  for (var item in users) {
    result.add(
      User(
        userId: "${item["userId"]}",
        nickname: item["nickname"],
        signature: item["signature"],
        avatarUrl: item["avatarUrl"],
      )
    );
  }
  return result;
}

