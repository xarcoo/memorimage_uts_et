import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memorimage_uts_et/class/question.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  bool animated = false;
  late Timer _timer;
  late Timer _timerGambar;
  double opacityLev = 0;
  List<Question> _questions = [];
  int i = 0;
  int j = 0;

  @override
  void initState() {
    super.initState();

    _questions = questions;
    _questions.shuffle();

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        animated = true;
      });
    });

    _timerGambar = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if(opacityLev == 0){
          opacityLev = 1;
          if(i == _questions.length - 1){
            timer.cancel();
            opacityLev = 0;
          }
          else{
            i++;

          }
        }
        else if(opacityLev == 1){
          opacityLev = 0;
        }
      });
    });
  }

  List<Widget> gambar(int i){
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

  void checkAnswer(String answer){

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
                    },
                    child: const Text('OK')
                )
              ],
            )
        );
      }
      else{
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
                    },
                    child: const Text('OK')
                )
              ],
            )
        );
      }
      
      if(j < questions.length - 1){
        j++;
      }
      else{
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
                    child: const Text('OK')
                )
              ],
            )
        );
      }
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
                child: Text("Get Ready"),
              )),
          Container(
              width: 250.0,
              height: _timerGambar.isActive ? 250.0 : 0,
              child: AnimatedOpacity(
                opacity: opacityLev,
                duration: const Duration(seconds: 1),
                child: Image.network(questions[i].answer),
              )
          ),
          Container(
            height: MediaQuery.of(context).size.height,
              child: GridView.count(
                crossAxisCount: 2,
                children: gambar(j),
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
