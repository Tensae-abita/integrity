import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/enter_password.dart';
import 'package:integrity/screens/first_page.dart';
// import 'package:integrity/screens/reviewer/auth.dart';
// import 'package:integrity/screens/reviewer/enter_password.dart';
// import 'package:integrity/screens/reviewer/success_register.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Verify_otp extends StatefulWidget {
  var phoneNumber;
  var countryCode;
  var verId;
  var userType;
  Verify_otp(
   { this.phoneNumber,
    required this.userType,
    this.verId,
    this.countryCode
    
   }
  );

  @override
  State<Verify_otp> createState() => _Verify_otpState();
}

class _Verify_otpState extends State<Verify_otp> {
  final _fireStore = FirebaseFirestore.instance;

  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  late Timer _timer;
int _start = 20;

void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}


  @override
  void initState() {
    startTimer();
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

  Future<void> verifyOtp(var v) async{
   
   try{
await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: widget.verId, 
        smsCode: v
        )
        ) .then((value)async{
          print(value);
    Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EnterPassword(
                  userType: widget.userType,
                  phoneNumber:widget.countryCode + widget.phoneNumber.text,)));

               
        }
        );
   } catch (e){
     errorController.add(ErrorAnimationType.shake); 

   }
    
  }
   Future<void> ResendOtp(var number) async{
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        // timeout: const Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential credential)async{
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) => print('logged in'));
        }, 
        verificationFailed: (FirebaseAuthException e){
          showSnackBarText("can't send code check if you have typed correct number");
        }, 
        codeSent: (String verificationId, int? resendToken) {
        widget.verId=verificationId;
        setState(() {
          // screenState = 1;
          
        });
      },
      codeAutoRetrievalTimeout: (String verificationId){
        
      });
    }
    
  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
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
                  Text(widget.countryCode +" "+ widget.phoneNumber.text),
                  SizedBox(
                    height: 50,
                  ),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: PinCodeTextField(
                    length: 6,
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
                    },
                    onChanged: (value) {
                      
                      setState(() {
                        currentText = value;
                        print(currentText);
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
                  Container(
                   
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(10)),
                             color: Colors.blue,
                       ),
                       width: MediaQuery.of(context).size.width*0.7,
                       height: 60,
                         child: TextButton(
                          
                          onPressed: ()async{
                            // print( widget.countryCode+widget.phoneNumber.text);
                            // print(countryCode+PhoneController.text);
                            if(currentText.length>=6){
                              verifyOtp(currentText);
                              
              
                            }else{
                              errorController.add(ErrorAnimationType.shake); 
                            }
                               
                            
                          }, child: Text("VERIFY",style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),)),
                       ),
                  SizedBox(height:30),
                 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Resent OTP in 00:${_start}?",style: TextStyle(
                        color: Colors.green[900],
                        fontWeight: FontWeight.w400
                      ),),
                      Visibility(
                        visible: _start==0?true:false,
                        child: TextButton(
                          onPressed: (){
                            ResendOtp(widget.countryCode+widget.phoneNumber.text);
                            _start=20;
                            startTimer();
                            
                          }, 
                          child: Text('RESEND')),
                      )
                    ],
                  ),
                 TextButton(
                  onPressed: (){
                    Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => First_page()));
                  }, 
                  child: Text("Change Number"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
