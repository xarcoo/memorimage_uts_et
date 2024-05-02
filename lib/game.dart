import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memorimage_uts_et/class/question.dart';
import 'package:memorimage_uts_et/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
int userPoint = 0;
int userGuess = 0;

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
  late Timer _timerSoal;
  bool animatedAnswer = false;
  bool animatedQuestion = false;
  double opacityLev = 1;
  double opLevSoal = 1;
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
          if (i == 4) {
            timer.cancel();
            opacityLev = 0;
            animatedAnswer = true;

            _timerSoal = Timer.periodic(Duration(seconds: 30), (timer) {
              setState(() {
                opLevSoal = 1;
                if (j == 4) {
                  timer.cancel();
                  // opLevSoal = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Result(),
                    ),
                  );
                } else {
                  j++;
                }
              });
            });
          } else {
            i++;
          }
        } else if (opacityLev == 1) {
          opacityLev = 0;
        }
      });
    });
  }

  List<TextButton> gambar(int i) {
    List<TextButton> temp = [];

    TextButton a = TextButton(
      child: Container(
        child: AnimatedOpacity(
          opacity: animatedAnswer == true ? opLevSoal : 0,
          duration: Duration(seconds: 1),
          child: Image.asset(_questions[i].option_a),
        ),
      ),
      onPressed: () {
        setState(() {
          checkAnswer(_questions[i].option_a);
        });
      },
    );
    TextButton b = TextButton(
      child: AnimatedOpacity(
        opacity: animatedAnswer == true ? opLevSoal : 0,
        duration: Duration(seconds: 1),
        child: Image.asset(_questions[i].option_b),
      ),
      onPressed: () {
        setState(() {
          checkAnswer(_questions[i].option_b);
        });
      },
    );
    TextButton c = TextButton(
      child: AnimatedOpacity(
        opacity: animatedAnswer == true ? opLevSoal : 0,
        duration: Duration(seconds: 1),
        child: Image.asset(_questions[i].option_c),
      ),
      onPressed: () {
        setState(() {
          checkAnswer(_questions[i].option_c);
        });
      },
    );
    TextButton d = TextButton(
      child: AnimatedOpacity(
        opacity: animatedAnswer == true ? opLevSoal : 0,
        duration: Duration(seconds: 1),
        child: Image.asset(_questions[i].option_d),
      ),
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
    super.dispose();
  }

  void checkAnswer(String answer) {
    setState(() {
      if (answer == _questions[j].answer) {
        userPoint += 100;
        userGuess += 1;
      } else {
        userPoint -= 50;
      }

      if (j < 4) {
        j++;
      } else {
        setScore();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Result(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                ? 50
                : MediaQuery.of(context).size.height,
            child: AnimatedAlign(
              alignment: animated ? Alignment.topCenter : Alignment.center,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
              child: Text(
                "Remember the Cards",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            margin: EdgeInsets.all(20),
          ),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),
          Container(
            width: 250.0,
            height: _timerGambar.isActive ? 250.0 : 0,
            child: AnimatedOpacity(
              opacity: opacityLev,
              duration: const Duration(seconds: 3),
              child: Image.asset(questions[i].answer),
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

  if (userPoint < 0) {
    userPoint = 0;
  }

  prefs.setInt("point", userPoint);
  prefs.setInt("guess", userGuess);

  userPoint = 0;
  userGuess = 0;
}
