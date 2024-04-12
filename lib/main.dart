import 'package:flutter/material.dart';
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
    return const MaterialApp(
      routes: {},
      title: 'UTS ET',
      home: const HomePage(title: "HEHE"),
    );
  }
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("username");
  LoginForm();
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
              accountName: Text("Satya"),
              accountEmail: Text(active_user),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150")),
            ),
            ListTile(
              title: new Text("High Score"),
              leading: new Icon(Icons.school),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => About()));  <=== Cara Panjang
                Navigator.pushNamed(context, "studentList");
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set  our appbar title.
        title: Text("Halaman Utama"),
      ),
    );
  }
}
