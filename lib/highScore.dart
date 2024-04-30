import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memorimage_uts_et/class/user_highscore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Highscore extends StatefulWidget {
  const Highscore({super.key});

  @override
  State<Highscore> createState() => _Highscore();
}

class _Highscore extends State<Highscore> {
  // ini untuk dapet list highscore
  List<UserHighscore> list_highscore = [];

  @override
  void initState() {
    List<UserHighscore> tmp = [];
    getHighscore().then((value) {
      setState(() {
        tmp = value.map((e) => UserHighscore.fromMap(jsonDecode(e))).toList();
        // ngambil 3 teratas
        for (var i = 0; i < tmp.length; i++) {
          list_highscore.add(tmp[i]);
          if (i >= 3) break;
        }
      });
    });

    super.initState();
  }

  // ini untuk dapet list highscore
  Future<List<String>> getHighscore() async {
    final sp_highscore = await SharedPreferences.getInstance();
    List<String> listTmp = sp_highscore.getStringList('highscore') ?? [];
    return listTmp;
  }

  List<Widget> widgets() {
    List<Widget> tmp = [];
    int i = 1;
    for (var item in list_highscore) {
      i++;
      Widget w = Container(
        child: Column(
          children: [
            Text(
              '$i. ' + item.username + '(' + item.score.toString() + ')',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
      tmp.add(w);
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HIGHSCORE"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text(
                'HIGHSCORE',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ...widgets(),
          ],
        ),
      ),
    );
  }
}
