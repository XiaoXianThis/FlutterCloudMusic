import 'package:flutter/material.dart';

import '../../data/Global.dart';
import '../pages/LogsPage.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            color: const Color(0xFFDD001B),
            child: const Padding(
              padding: EdgeInsets.all(0),
              child: Icon(Icons.music_note_outlined, color: Colors.white),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(3)),
        const Text("简易云音乐", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600)),
        const SizedBox(width: 80, child: Text("  v0.1", style: TextStyle(fontSize: 12, color: Colors.black38),)),
      ],
    );
  }
}


