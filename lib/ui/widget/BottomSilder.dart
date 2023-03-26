import 'package:flutter/material.dart';
import 'package:music/data/Global.dart';

import 'MiniSlider.dart';

class BottomSlider extends StatefulWidget {
  BottomSlider(this.value, {Key? key}) : super(key: key);

  double value = 0;

  @override
  State<BottomSlider> createState() => _BottomSliderState();
}

class _BottomSliderState extends State<BottomSlider> {
  double height = 4;
  bool isOnChange = false;
  double cacheValue = 0;
  @override Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        onEnter: (event)=>setState(() {
          height = 8;
        }),
        onExit: (event)=>setState(() {
          height = 4;
        }),
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
            max: 1,
            value: (){
              if(isOnChange){
                return cacheValue;
              } else {
                return widget.value;
              }
            }(),
            onChanged: (value) {
              setState(() {
                widget.value = value;
                cacheValue = value;
              });
            },
            onChangeStart: (value){
              setState(() {
                isOnChange = true;
              });
            },
            onChangeEnd: (value){
              global.player.seek(value);
              setState(() {
                isOnChange = false;
              });
            },
          ),
        ),
      ),
    );
  }
}


