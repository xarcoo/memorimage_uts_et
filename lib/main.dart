import 'package:flutter/material.dart';
import 'package:memorimage_uts_et/game.dart';
import 'package:memorimage_uts_et/highscore.dart';
import 'package:memorimage_uts_et/result.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("username") ?? '';
  return username;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(LoginForm());
    else {
      active_user = result;
      runApp(MainApp());
    }
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'game': (context) => Game(),
        'highScore': (context) => Highscore(),
        'login': (context) => LoginForm(),
        'result': (context) => Result(),
      },
      title: 'UTS ET',
      home: const HomePage(title: "HEHE"),
    );
  }
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  active_user = "";
  prefs.remove("username");
  prefs.remove("point");
  prefs.remove("guess");
  main();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 16.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(active_user),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150")),
            ),
            ListTile(
              title: new Text("High Score"),
              leading: new Icon(Icons.scoreboard),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => About()));  <=== Cara Panjang
                Navigator.pushNamed(context, "highScore");
              },
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              title: new Text("Log Out"),
              leading: new Icon(Icons.logout),
              onTap: () {
                active_user != ""
                    ? doLogout()
                    : Navigator.pushNamed(context, "login");
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Halaman Utama"),
      ),
      body: Column(
        children: [
          Container(
            height: 500,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remember the Cards",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    height: 50,
                    color: Colors.transparent,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Game()));
                    },
                    child: Text("Play Game"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
