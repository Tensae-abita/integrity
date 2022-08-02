import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/reviewer/success_register.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Verify_otp extends StatefulWidget {
  Verify_otp({Key? key}) : super(key: key);

  @override
  State<Verify_otp> createState() => _Verify_otpState();
}

class _Verify_otpState extends State<Verify_otp> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                 
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text('Enter Your code',style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[900]
                    ),),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('We sent an SMS with 6-digit code to',style: TextStyle(
                   
                  ),),
                  SizedBox(height:5),
                  Text('+2253432'),
                  SizedBox(
                    height: 50,
                  ),
                Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: PinCodeTextField(
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      selectedColor:Colors.green[900],
                      selectedFillColor:Colors.green[900],
                      inactiveColor: Colors.white,
                      inactiveFillColor:Colors.grey[300],
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(15),
                      fieldHeight: MediaQuery.of(context).size.width*0.15,
                      fieldWidth: MediaQuery.of(context).size.width*0.15,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.white,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (v) {
                      print("Completed");
                       Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Success()),
                              );
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    }, appContext: context,
                  ),
                  ),
                  SizedBox(height:50),
                  Text("Resent OTP in 00:20?",style: TextStyle(
                    color: Colors.green[900],
                    fontWeight: FontWeight.w400
                  ),)
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}