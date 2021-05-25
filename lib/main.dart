import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:bitsdojo_window/bitsdojo_window.dart';


var channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:8080/user'));
// var userChannel =
//     IOWebSocketChannel.connect(Uri.parse('ws://localhost:8080/userws'));

void main() {
  runApp(MyApp());

  channel.stream.listen((message) {

    print(message);
    // channel.sink.add('received home!');
    // channel.sink.close(status.goingAway);
  });
  // userChannel.stream.listen((message) {
  //   // userChannel.sink.add('received user!');
  //   // channel.sink.close(status.goingAway);
  // });
  doWhenWindowReady(() {
    final win = appWindow;
    final initialSize = Size(300, 400);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

const borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pieces Client',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
            body: WindowBorder(
                color: borderColor,
                width: 1,
                child: Row(children: [_MyHomePageState()]))));
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

const backgroundStartColor = Color(0x424242);
const backgroundEndColor = Color(0xFAFAFA);

class _MyHomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundStartColor, backgroundEndColor],
                  stops: [0.0, 1.0]),
            ),
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                Expanded(child: MoveWindow()),
                WindowButtons()
              ])),
              SizedBox(height: 120),
              FloatingActionButton(

                onPressed: () async {
                  var url = Uri.parse('http://localhost:8080/user');

                  Map<String, String> headers = {
                    'Content-type': 'application/json',
                    'Accept': 'application/json',
                  };

                  var response = await http.post(url,
                      body: json.encode({'name': 'doodle', 'color': 'blue'}),
                      headers: headers);
                  print('Response status: ${response.statusCode}');
                  print(
                      'Response body: ${response.body}'); // channel.sink.add('Hello! Pieces Server');
                  // channel.sink.add('hello from this home');
                },
                tooltip: 'Send',
                child: Icon(Icons.send),
              ),
            ])));
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: Color(0xFF805306),
    mouseOver: Color(0xFFF6A00C),
    mouseDown: Color(0xFF805306),
    iconMouseOver: Color(0xFF805306),
    iconMouseDown: Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: Color(0xFFD32F2F),
    mouseDown: Color(0xFFB71C1C),
    iconNormal: Color(0xFF805306),
    iconMouseOver: Colors.white);

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
