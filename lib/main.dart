import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/screens/first_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:integrity/screens/login_page.dart';
import 'package:integrity/screens/reviewer/Reviewer_pages/home_page.dart';
import 'package:integrity/views/service_provider/service_home_page.dart';
import 'package:is_first_run/is_first_run.dart';

void main() async{
 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
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
    return GetMaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
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

  final box=GetStorage();
  String? userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(box!=null)
      {
       userId= box.read('id');
      }
    StartTime();
  }
Future<Timer> StartTime()async{
    firstRun = await IsFirstRun.isFirstRun();
var duration=Duration(milliseconds: 1500);
return Timer(duration, route);
}
 
 route()async{
  if(userId==null)
    {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>firstRun? First_page(
        isRecovoring: false,):LogIn_page()));
    }
  else
    {
      FirebaseFirestore.instance.collection('users').where('userid',isEqualTo: userId).get().then((value) =>
      {
        for(var data in value.docs){
         if(data.data()['usertype']=="Reviewer"){
         Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Reviewer_Home_Page()))

         }else if(data.data()['usertype']=="Service Provider"){
         Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Provider_Home_Page()))
         }
       }
      });
    }
 }

  Widget build(BuildContext context) {
    return Container(
      child:Image.asset('assets/images/home.png')
    );
  }
  

}

