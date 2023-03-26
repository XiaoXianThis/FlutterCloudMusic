import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/ui/pages/SearchPage/SearchPage.dart';

//搜索类型选择
typedef OnSearchTabBarChange = Function();
class SearchTabBar extends StatefulWidget {
  const SearchTabBar({
    Key? key,
    required this.tabs,
    required this.extendTabs,
    required this.callback,
    required this.controller,
  }) : super(key: key);

  final List<String> tabs;  // 所有类型选项，如：[ "单曲", "歌手", "专辑", ... ]
  final List<String> extendTabs;  // 第三方平台，如：[ "Spotify" ]
  final SearchPageController controller;      // 当前的搜索类型
  final OnSearchTabBarChange callback;    //当所选下标改变时回调

  @override
  State<SearchTabBar> createState() => _SearchTabBarState();
}

class _SearchTabBarState extends State<SearchTabBar> {
  @override Widget build(BuildContext context) {
    return Row(
      children: ((){
        List<Widget> widgets = [];
        for(var i = 0; i<widget.tabs.length; i++){
          var item = widget.tabs[i];
          widgets.add(
            GestureDetector(
              onTap: ()=>setState(() {
                widget.controller.searchType.value = SearchType.keymap[i] ?? 0;
                widget.callback();
              }),
              child: Obx((){
                return Container(
                  width: 60, height: 30,
                  decoration: BoxDecoration(
                    color: Color(
                        ((){
                          if(SearchType.keymap[i] == widget.controller.searchType.value) {
                            return 0xFFEC4141;
                          } else {
                            return 0x00FFFFFF;
                          }
                        }())
                    ),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Center(
                    child: Text(
                        item,
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(((){
                              if(SearchType.keymap[i] == widget.controller.searchType.value) { return 0xFFFFFFFF; } else { return 0xff333333; }
                            }())),
                            fontWeight: ((){
                              if(SearchType.keymap[i] == widget.controller.searchType.value) { return FontWeight.bold; } else { return FontWeight.normal; }
                            }())
                        )
                    ),
                  ),
                );
              }),
            )
          );
        }

        widgets.add(const SizedBox(width: 30));
        widgets.add(const Text("其他平台", style: TextStyle(color: Colors.black38, fontSize: 12), ));
        widgets.add(const SizedBox(width: 8));
        for(var i = widget.tabs.length; i<widget.tabs.length + widget.extendTabs.length; i++){
          var item = widget.extendTabs[i-widget.tabs.length];
          widgets.add(
              Stack(
                children: [
                  GestureDetector(
                    onTap: ()=>setState(() {
                      widget.controller.searchType.value = SearchType.keymap[i] ?? 0;
                      widget.callback();
                    }),
                    child: Obx((){
                      return  Container(
                        width: 80, height: 30,
                        decoration: BoxDecoration(
                          color: Color(
                              ((){
                                if(SearchType.keymap[i] == widget.controller.searchType.value) {
                                  return 0xFF1ED760;
                                } else {
                                  return 0x00FFFFFF;
                                }
                              }())
                          ),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: Center(
                          child: Text(
                              item,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(((){
                                    if(SearchType.keymap[i] == widget.controller.searchType.value) { return 0xFFFFFFFF; } else { return 0xff333333; }
                                  }())),
                                  fontWeight: ((){
                                    if(SearchType.keymap[i] == widget.controller.searchType.value) { return FontWeight.bold; } else { return FontWeight.normal; }
                                  }())
                              )
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              )
          );
        }
        return widgets;
      }()),
    );
  }
}



