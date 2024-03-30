import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:my_messenger/screens/splash_screen.dart';
import 'firebase_options.dart';

//global object for accessing device screen size
late Size
    mq; //media query should be initialized in a widget whose parent widget is a material app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode
      .immersiveSticky); //this sets the screen size i.e. full screen size  for splash screen
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buddy Chat',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.white,
      )),
      home: const splash_screen(),
    );
  }
}

_initializeFirebase() async {
  //Async keyword is used to achieve asynchronus vlues
  //async returns future object whereas async* returns Stream object
  //async is necessary if await is used but it is not necessary vice versa
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
