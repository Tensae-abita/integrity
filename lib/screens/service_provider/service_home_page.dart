import 'package:flutter/material.dart';


class Provider_Home_Page extends StatefulWidget {
  Provider_Home_Page({Key? key}) : super(key: key);

  @override
  State<Provider_Home_Page> createState() => Provider__Home_PageState();
}

class Provider__Home_PageState extends State<Provider_Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Text('Service Provider Home Page'),
          ),
        ),
      ),
    );
  }
}