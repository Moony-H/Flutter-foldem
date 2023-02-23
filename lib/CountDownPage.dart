import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foldem/setting_page.dart';
import 'package:foldem/widget/CountDowmTimer.dart';

import 'model/Round.dart';

class CountDownPage extends StatefulWidget {
  final List<Round> rounds;
  var _roundIndex = 0;

  Round get nowRound {
    return rounds[_roundIndex];
}

  CountDownPage({super.key, required this.rounds});

  @override
  _CountDownPageState createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage>
    with TickerProviderStateMixin {
  late final AnimationController controller;

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RoundSettingPage(items: widget.rounds)));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Column(
            children: [
          Expanded(
            flex: 5,
              child: CountDownTimer(
            timeSec: widget.nowRound.timeSec,
          )),
          Expanded(child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(child: Text('Small Blind: ${widget.nowRound.smallBlind}'),),
                Card(child: Text('Big Blind: ${widget.nowRound.bigBlind}'),)
              ],
            ),
          ))
        ]));
  }
}
