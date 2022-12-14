import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/first_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:integrity/screens/login_page.dart';
import 'package:is_first_run/is_first_run.dart';

void main() async{
 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home()
    );
  }
}

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePage();
  }

}

class HomePage extends State<Home>{
  late bool firstRun;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StartTime();
  }
Future<Timer> StartTime()async{
    firstRun = await IsFirstRun.isFirstRun();
var duration=Duration(milliseconds: 1500);
return Timer(duration, route);
}
 
 route()async{

  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>firstRun? First_page(
    isRecovoring: false,
  ):LogIn_page()));
 }

  Widget build(BuildContext context) {
    return
    Container(
      child:Image.asset('assets/images/home.png')
    );
  }
  

}

