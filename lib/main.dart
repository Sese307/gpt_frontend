import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String r_value = '';
  TextEditingController _inputController = TextEditingController();

  Future<void> createAnimal(String title) async {
    final response = await http.post(
      Uri.parse('http://23.95.200.8:3000/animal?name=$title'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }
      // ),
    );
    setState(() {
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        // return Animal.fromJson(jsonDecode(response.body));
        r_value = Animal.fromJson(jsonDecode(response.body)).title;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print(response.body);
        throw Exception('Failed to create Animal.');
      }
    });
  }

  Future<void> createIntro(String title) async {
    final response = await http.post(
      Uri.parse('http://23.95.200.8:3000/downloadlink?name=$title'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'title': title,
      // }
      // ),
    );
    setState(() {
      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        // return Animal.fromJson(jsonDecode(response.body));
        //r_value = Animal.fromJson(jsonDecode(response.body)).title;
        r_value = Animal.fromJson(json.decode(utf8.decode(response.bodyBytes))).title;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        print(response.body);
        throw Exception('Failed to create Animal.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: const Text(
                  'The predict name of the animal is',
                ),
              ),
            ),
            Text(
                r_value,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            Expanded(
              flex: 3,
              child: ListView(
                children: [
                  TextButton(
                    onPressed: () async {
                      await createAnimal('mouse');
                    },
                    child: const Text("Name"),
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _inputController,
                    decoration: InputDecoration(
                        labelText: '内容', hintText: '请输入介绍', icon: Icon(Icons.person)),
                  ),
                  TextButton(
                    onPressed: () async {
                      await createIntro(_inputController.text);
                    },
                    child: const Text("Create Intro"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await createAnimal('mouse');
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Animal {
  final String title;

  const Animal({required this.title});

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      title: json['result'],
    );
  }
}
