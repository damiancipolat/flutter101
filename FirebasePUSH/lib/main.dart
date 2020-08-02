import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  String token = await new PushNotificationsManager().init();
  log(token);
  print(token);

  runApp(MyApp());
}

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<String> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          //Se ejecuta cuando llega un mensaje y la app esta en 1er plano.
          print("onMessage: $message");
          // _showItemDialog(message);
        },
        onBackgroundMessage: (Map<String, dynamic> message) async {
          print("onBackgroundMessage: $message");
          // _navigateToItemDetail(message);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          // _navigateToItemDetail(message);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          // _navigateToItemDetail(message);
        },
      );

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      log("!!!!!!!FirebaseMessaging token: $token");
      print("!!!!!!!FirebaseMessaging token: $token");

      _initialized = true;
      return token;
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void crashClick() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crashClick,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
