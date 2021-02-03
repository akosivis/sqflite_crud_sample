import 'package:flutter/material.dart';

import 'database/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SqfliteDemo(title: 'SQflite Demo'),
    );
  }
}

class SqfliteDemo extends StatefulWidget {
  SqfliteDemo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SqfliteDemoState createState() => _SqfliteDemoState();
}

class _SqfliteDemoState extends State<SqfliteDemo> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  void insertNote(String title, String content) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle : title,
      DatabaseHelper.columnContent : content
    };

    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text("Add a new item"),
                        onPressed: () {

                        },
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text("Refresh list"),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Center(
                      child: Container(child: Text("Future list")),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
