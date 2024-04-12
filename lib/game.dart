import 'dart:async';

import 'package:flutter/material.dart';

class Game extends StatefulWidget{
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool animated = false;
  late Timer _timer;
  double opacityLev = 0;

  @override
  void initState(){
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        animated = true;
        opacityLev = 0 + 1;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("History"),
      // ),
      body: ListView(
        children: [
          Container(
              width: 250.0,
              height: 250.0,
              child: AnimatedAlign(
                alignment: animated ? Alignment.topCenter : Alignment.center,
                duration: const Duration(seconds: 3),
                curve: Curves.fastOutSlowIn,
                child:
                Text("Get Ready"),
              )
          ),
          Container(
              width: 250.0,
              height: 250.0,
              child: AnimatedOpacity(
                opacity: opacityLev,
                duration: const Duration(seconds: 1),
                child:
                Image.network('https://loremflickr.com/320/240/cake?lock=9'),
              )
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('animation test'),
      ),
    );
  }
}