import 'package:flutter/material.dart';
import 'package:music/ui/widget/BottomLeftWidget.dart';
import 'package:music/ui/widget/BottomPlayerWidget.dart';
import 'package:music/ui/widget/BottomRightButtons.dart';


//底栏
class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
            child: BottomLeftWidget()
        ),
        Expanded(
            child: Align(
              alignment: Alignment.center,
              child: BottomPlayerWidget(),
            ),
          flex: 2,
        ),
        Expanded(
            child: BottomRightButtons()
        ),
      ],
    );
  }
}


