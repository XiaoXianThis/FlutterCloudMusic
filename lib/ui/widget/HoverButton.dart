import 'package:flutter/material.dart';
import 'package:music/ui/widget/HoverView.dart';

//状态
enum Status {
  normal,     //未选中
  hover,      //鼠标进入
  selected,   //选中
}


class HoverButton extends StatefulWidget {
  const HoverButton(
      this.index,                 //下标
      this.icon,                  //图标
      this.text, {               //文字
      Key? key,
      this.onTap,                  //点击事件
      this.selected = false,      //是否处于选中状态
      this.rightWidget
  }) : super(key: key);

  final int index;
  final bool selected;
  final IconData icon;
  final String text;
  final GestureTapCallback? onTap;
  final Widget? rightWidget;


  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  Status status = Status.normal;
  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: HoverView(
        height: 50,
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        radius: 8,
        child: Row(
          children: [
            Icon(widget.icon, size: 18,),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
                  widget.text,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                )
            ),
            Center(
              child: widget.rightWidget,
            )
          ],
        ),
      ),
    );
  }

}