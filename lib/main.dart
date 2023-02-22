import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foldem/main_page.dart';
import 'package:foldem/setting_page.dart';
import 'package:foldem/sample.dart';
import 'package:foldem/widget/CountDownTimer.dart';

final items = List.generate(10, (i) {
  print('list changed');
  return Round(
      smallBlind: (i + 1) * 100, bigBlind: (i + 1) * 200, ante: 0, timeSec: 600);
});

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Foldem');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListTest(items: items,)//CountDownTimer()//ListTest(items: items,),
      //scrollBehavior: AppScrollBehavior(),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
