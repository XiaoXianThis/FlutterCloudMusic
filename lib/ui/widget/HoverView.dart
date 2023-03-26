import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


//布局状态
enum HoverViewState {
  normal,         //正常状态
  hover,          //鼠标移入
  selected,       //选中状态
}

//鼠标移入后有提示的布局
class HoverView extends StatefulWidget {
  HoverView(
      {
        Key? key,
        this.height,
        this.radius = 8,
        required this.child,
        this.padding,
        this.normalColor = const Color(0x00ffffff),
        this.hoverColor = const Color(0x0A000000),
        this.selectedColor = const Color(0x0A000000),
        this.state = HoverViewState.normal,
        this.border,
      }
  ) : super(key: key);

  Widget child;                                              //子布局
  double radius;                                         //圆角
  HoverViewState state;                                       //布局状态
  EdgeInsetsGeometry? padding;                              //边距
  Color? normalColor;                                     //未选中时 背景颜色
  Color? hoverColor;                                       //鼠标移入 背景颜色
  Color? selectedColor;                                    //选中时 背景颜色
  double? height;                                         //高度
  BoxBorder? border;                                      //边框



  @override State<HoverView> createState() => _HoverViewState();
}

class _HoverViewState extends State<HoverView> {

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event)=>setState(() {
        widget.state = HoverViewState.hover;
      }),
      onExit: (event) => setState(() {
        widget.state = HoverViewState.normal;
      }),
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: widget.padding,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: widget.border,
          color: (){
            if(widget.state == HoverViewState.normal){ return widget.normalColor; }
            else if(widget.state == HoverViewState.hover){ return widget.hoverColor; }
            else if(widget.state == HoverViewState.selected){ return widget.selectedColor; }
          }(),
        ),
        child: widget.child,
      ),
    );
  }
}

