import 'package:flutter/material.dart';

//
class MiniSlider extends StatefulWidget {
  const MiniSlider({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<MiniSlider> createState() => _MiniSliderState();
}

class _MiniSliderState extends State<MiniSlider> {
  double height = 4;
  bool isOnChange = false;
  double cacheValue = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 20,
        child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              inactiveTrackColor: const Color(0xFFCECECE),
              thumbColor: Colors.red,
              activeTrackColor: Colors.red,
              overlayColor: const Color(0x00FF0000),
              trackShape: WDCustomTrackShape(addHeight: height),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: (){
                if(isOnChange){
                  return cacheValue;
                } else {
                  return widget.value;
                }
              }(),
              onChanged: (value) {
                widget.onChanged(value);
                setState(() {
                  cacheValue = value;
                });
              },
              onChangeStart: (value){
                setState(() {
                  isOnChange = true;
                });
              },
              onChangeEnd: (value){
                setState(() {
                  isOnChange = false;
                });
              },
            )
        ),
      ),
    );
  }
}



//自定义进度条形状
class WDCustomTrackShape extends RoundedRectSliderTrackShape {

  WDCustomTrackShape({this.addHeight = 0});
  //增加选中滑块的高度,系统默认+2·
  double addHeight;

  ///去掉默认边距
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight??1;
    final double trackLeft = offset.dx+10;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width-20;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset, {required RenderBox parentBox, required SliderThemeData sliderTheme, required Animation<double> enableAnimation, required TextDirection textDirection, required Offset thumbCenter, Offset? secondaryOffset, bool isDiscrete = false, bool isEnabled = false, double additionalActiveTrackHeight = 2}) {
      super.paint(context, offset, parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      additionalActiveTrackHeight: addHeight
    );
  }

// void paint(
//     PaintingContext context,
//     Offset offset, {
//       required RenderBox parentBox,
//       required SliderThemeData sliderTheme,
//       required Animation<double> enableAnimation,
//       required TextDirection textDirection,
//       required Offset thumbCenter,
//       bool isDiscrete = false,
//       bool isEnabled = false,
//       double additionalActiveTrackHeight = 0,
//     }) {
//   super.paint(context, offset, parentBox: parentBox,
//       sliderTheme: sliderTheme,
//       enableAnimation: enableAnimation,
//       textDirection: textDirection,
//       thumbCenter: thumbCenter,
//       additionalActiveTrackHeight: addHeight
//   );
// }
}
