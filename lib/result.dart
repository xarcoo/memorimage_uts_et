import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memorimage_uts_et/game.dart';
import 'package:memorimage_uts_et/highscore.dart';
import 'package:memorimage_uts_et/class/user_highscore.dart';
import 'package:memorimage_uts_et/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Map<String, dynamic> _prefs = {};
String active_user = "";
int right_guess = 0;
int point = 0;
String user_title = "";
List<UserHighscore> list = [];

Future<List<String>> getHighscore() async {
  final sp_highscore = await SharedPreferences.getInstance();
  List<String> listTmp = sp_highscore.getStringList('highscore') ?? [];
  return listTmp;
}

Future<Map<String, dynamic>> getPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  active_user = prefs.getString("username") ?? "";
  right_guess = prefs.getInt("guess") ?? 0;
  point = prefs.getInt('point') ?? 0;

  return {'user': active_user, 'guess': right_guess, 'point': point};
}

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _Result();
}

class _Result extends State<Result> {
  // ini untuk dapet list highscore
  List<UserHighscore> list_highscore = [];
  @override
  void initState() {
    // ini untuk dapet list highscore
    getHighscore().then((value) {
      setState(() {
        list_highscore =
            value.map((e) => UserHighscore.fromMap(jsonDecode(e))).toList();
      });
    });

    super.initState;

    getPrefs().then((value) {
      setState(() {
        _prefs = value;

        if (_prefs['guess'] == 5) {
          user_title = "Maestro dell'Indovinello (Master of Riddles)";
        } else if (_prefs['guess'] == 4) {
          user_title = "Esperto dell'Indovinello (Expert of Riddles)";
        } else if (_prefs['guess'] == 3) {
          user_title = "Abile Indovinatore (Skillful Guesser)";
        } else if (_prefs['guess'] == 2) {
          user_title = "Principiante dell'Indovinello (Riddle Beginner)";
        } else if (_prefs['guess'] == 1) {
          user_title = "Neofita dell'Indovinello (Riddle Novice)";
        } else if (_prefs['guess'] == 0) {
          user_title = "Sfortunato Indovinatore (Unlucky Guesser)";
        }

        addHighscore(UserHighscore(_prefs['user'], _prefs['point']));
      });
    });
  }

  Future<List<String>> getHighscore() async {
    final sp_highscore = await SharedPreferences.getInstance();
    List<String> listTmp = sp_highscore.getStringList('highscore') ?? [];
    return listTmp;
  }

  void addHighscore(UserHighscore uh) async {
    final prefsAdd = await SharedPreferences.getInstance();
    if (list_highscore.isEmpty) {
      list_highscore.add(uh);
    } else if (list_highscore.length == 1) {
      list_highscore.add(uh);

      list_highscore.sort((b, a) => a.score.compareTo(b.score));
    } else {
      list_highscore.add(uh);

      list_highscore.sort((b, a) => a.score.compareTo(b.score));
      if (list_highscore.length > 3) {
        list_highscore.removeLast();
      }
    }

    List<String> listTemp =
        list_highscore.map((e) => jsonEncode(e.toMap())).toList();
    prefsAdd.setStringList('highscore', listTemp);
  }

  // void setHighscore() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   // untuk urut berdasarkan score
  //   list.sort((a, b) => a.score.compareTo(b.score));
  //   list.reversed;

  //   // masukin ke prefs
  //   List<String> list_highscore =
  //       list.map((e) => jsonEncode(e.toMap())).toList();
  //   prefs.setStringList("highscore", list_highscore);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RESULT"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                'Congratulation champ $active_user!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: Text(
                'the $user_title',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Game(),
                      ),
                    );
                  },
                  child: Text("Play Again"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Highscore(),
                      ),
                    );
                  },
                  child: Text("High Scores"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainApp(),
                      ),
                    );
                  },
                  child: Text("Main Menu"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
