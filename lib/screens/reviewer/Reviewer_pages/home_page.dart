import 'package:flutter/material.dart';


class Reviewer_Home_Page extends StatefulWidget {
  Reviewer_Home_Page({Key? key}) : super(key: key);

  @override
  State<Reviewer_Home_Page> createState() => Reviewer__Home_PageState();
}

class Reviewer__Home_PageState extends State<Reviewer_Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Container(
            child: Text('Reviewer home page'),
          ),
        ),
      ),
    );
  }
}