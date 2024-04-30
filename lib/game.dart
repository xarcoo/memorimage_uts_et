import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memorimage_uts_et/class/question.dart';
import 'package:memorimage_uts_et/class/user_highscore.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
int userPoint = 0;

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool animated = false;
  late Timer _timer;
  late Timer _timerGambar;
  bool animatedAnswer = false;
  bool animatedQuestion = false;
  double opacityLev = 0;
  List<Question> _questions = [];
  int i = 0;
  int j = 0;

  @override
  void initState() {
    super.initState();

    checkUser().then((value) {
      setState(() {
        active_user = value;
      });
    });

    _questions = questions;
    _questions.shuffle();

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        animated = true;
      });
    });

    _timerGambar = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      setState(() {
        animatedQuestion = true;
        if (opacityLev == 0) {
          opacityLev = 1;
          if (i == _questions.length - 1) {
            timer.cancel();
            opacityLev = 0;
            animatedAnswer = true;
          } else {
            i++;
          }
        } else if (opacityLev == 1) {
          opacityLev = 0;
        }
      });
    });
  }

  List<Widget> gambar(int i) {
    List<Widget> temp = [];

    Widget a = TextButton(
      child: Image.network(_questions[i].option_a),
      onPressed: () {
        setState(() {
          checkAnswer(_questions[i].option_a);
        });
      },
    );
    Widget b = TextButton(
      child: Image.network(_questions[i].option_b),
      onPressed: () {
        setState(() {
          checkAnswer(_questions[i].option_b);
        });
      },
    );
    Widget c = TextButton(
      child: Image.network(_questions[i].option_c),
      onPressed: () {
        setState(() {
          checkAnswer(_questions[i].option_c);
        });
      },
    );
    Widget d = TextButton(
      child: Image.network(_questions[i].option_d),
      onPressed: () {
        setState(() {
          checkAnswer(_questions[i].option_d);
        });
      },
    );

    temp.add(a);
    temp.add(b);
    temp.add(c);
    temp.add(d);

    return temp;
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerGambar.cancel();
    // _hitung = 0;
    super.dispose();
  }

  // finishGame() {
  //   _timer.cancel();
  //   _timerGambar.cancel();
  //   j = 0;
  // }

  void checkAnswer(String answer) {
    setState(() {
      if (answer == _questions[j].answer) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Quiz'),
            content: Text('Betul'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => TopPlayer()));
                  Navigator.of(context).pop();
                  userPoint += 100;
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Quiz'),
            content: Text('Salah'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => TopPlayer()));
                  Navigator.of(context).pop();
                  userPoint -= 50;
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      }

      if (j < questions.length - 1) {
        j++;
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Quiz'),
            content: Text('Tamat'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => TopPlayer()));
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("GAME"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          Container(
            width: 250.0,
            height: animatedQuestion == true
                ? 20.0
                : MediaQuery.of(context).size.height,
            child: AnimatedAlign(
              alignment: animated ? Alignment.topCenter : Alignment.center,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: Text("Get Ready"),
            ),
          ),
          Container(
            width: 250.0,
            height: _timerGambar.isActive ? 250.0 : 0,
            child: AnimatedOpacity(
              opacity: opacityLev,
              duration: const Duration(seconds: 3),
              child: Image.network(questions[i].answer),
            ),
          ),
          Container(
            width: 25.0,
            height:
                animatedAnswer == true ? MediaQuery.of(context).size.height : 0,
            child: GridView.count(
              childAspectRatio: (1 / .4),
              crossAxisCount: 2,
              children: gambar(j),
            ),
          ),
        ],
      ),
    );
  }
}

void setScore() async {
  final prefs = await SharedPreferences.getInstance();

  // masukin ke prefs
  prefs.setString("username", active_user);
  prefs.setInt("highscore", userPoint);
}
