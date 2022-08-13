import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/first_page.dart';
import 'package:integrity/screens/reviewer/Reviewer_pages/home_page.dart';
import 'package:integrity/screens/service_provider/service_home_page.dart';
import 'package:integrity/screens/verify_otp.dart';
// import 'package:integrity/screens/reviewer/auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:password_text_field/password_text_field.dart';



class LogIn_page extends StatefulWidget {
  LogIn_page({Key? key}) : super(key: key);

  @override
  State<LogIn_page> createState() => _LogIn_pageState();
}

class _LogIn_pageState extends State<LogIn_page> {
      GlobalKey<FormState> _formKey = GlobalKey();
    TextEditingController PhoneController=TextEditingController();
    TextEditingController PasswordController=TextEditingController();

  final _fireStore = FirebaseFirestore.instance;

    var countryCode ="+251";
    var PhoneNUmber="";
    var verId='';
    var userType='';
    var isMultipleAcount;

  bool modal=false;

  Future<void> userSignIn() async {
    var bytes = utf8.encode(PasswordController.text); // data being hashed

  var digest = sha256.convert(bytes);
    setState(() {
      
      modal=true;
    });
    print(digest);
    await  _fireStore.collection('users') .where('phone', isEqualTo:countryCode+ PhoneController.text,)
          .get()
          .then((value) async { if(value.size > 0 ){
            for(var data in value.docs){
              
              // print(PasswordController.text)  ;
              if(digest.toString()==data.data()['password']){
                print('match');
                  setState(() {
                    modal=false;
                  });
                  if(data.data()['usertype']=="Reviewer"){
                  Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Reviewer_Home_Page()));

                  }else if(data.data()['usertype']=="Service Provider"){
                  Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Provider_Home_Page()));

                  }

              }
            }
            }else{
               setState(() {
                    modal=false;
                  });
              showSnackBarText('UserName and Password Do not match');
            }
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
      child:ModalProgressHUD(
        inAsyncCall: modal,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height: MediaQuery.of(context).size.height*0.2,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Text('Sign In',style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[900]
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    // Text('Enter Mobile Number we will',style: TextStyle(
                     
                    // ),),
                    // SizedBox(height:5),
                    // Text('Send you OTP'),
                    SizedBox(height:20),
                    Form(
                      key: _formKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        child: IntlPhoneField(
                          showCountryFlag: false,
                          controller: PhoneController,
                            decoration: InputDecoration(
                                labelText: 'Enter Mobile Number',
                                border: OutlineInputBorder(
                                  
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                            ),
                            initialCountryCode: 'ET',
                            initialValue: countryCode,
                            onCountryChanged: (country){
                              setState(() {
                                countryCode="+${country.dialCode}";
                              });
                              
                            },
                            onChanged: (phone) {
                                // print(phone.completeNumber);
                            },
                        ),
                      ),
                      
                    ),
                       Container(
                        width: MediaQuery.of(context).size.width*0.7,
                         child: PasswordTextField(
                          controller: PasswordController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
                          
                       ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Forgot password'),
                      TextButton(
                        onPressed: ()async{
                          setState(() {
                            modal=true;
                          });
await  _fireStore.collection('users') .where('phone', isEqualTo:countryCode+ PhoneController.text,)
          .get()
          .then((value) async { if(value.size > 0 ){
            if(value.size == 1 ){
            for(var data in value.docs){
              userType = data.data()['usertype'];
              isMultipleAcount=false;
              print(isMultipleAcount);
            }
           
            }else if(value.size > 1){
              isMultipleAcount=true;
              print(isMultipleAcount);
            }else if(value.size == 0){
               setState(() {
                            modal=false;
                          });
               showSnackBarText('do not have acount create acount first');

            }
            }});
if(modal==true){
await   FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:countryCode+ PhoneController.text,
        // timeout: const Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential credential)async{
          // await FirebaseAuth.instance.signInWithCredential(credential).then((value) => print('logged in'));
          // modal=false;
        }, 
        verificationFailed: (FirebaseAuthException e){
          setState(() {
              modal=false;
            });
           
          showSnackBarText("can't send code check if you have typed correct number");

        }, 
        codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        setState(() {
          print(verId);
          print(PhoneController);
          // screenState = 1;
          modal=false;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>!isMultipleAcount?Verify_otp(
                  phoneNumber: PhoneController,
                  countryCode: countryCode,
                  verId: verId,
                  userType: userType,
                  isRecovering: true,
                ):First_page(
                  isRecovoring: true,
                  verId: verId,
                  phoneNumber:countryCode + PhoneController.text,
                  )),
              );
        });
      },
      codeAutoRetrievalTimeout: (String verificationId){

      });
}

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Verify_otp(userType: 'recover')));
                        }, 
                        child: Text("Recover"))
                    ],
                  ),

                    SizedBox(
                      height: 20,
                    ),
                    Container(
                     
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(10)),
                               color: Colors.blue,
                         ),
                         width: MediaQuery.of(context).size.width*0.7,
                         height: 60,
                           child: TextButton(
                            
                            onPressed: (){
                              userSignIn();
                              
                            //   // print(countryCode+PhoneController.text);
                            //     var val=_formKey.currentState?.validate();
                            //   if (val ==true){
                                
                                  
                            //     // verifyPhone(countryCode+PhoneController.text);
                            //  }
                            }, child: Text("Sign In",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),)),
                         ),
                         Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Dont have an account'),
                      TextButton(
                        onPressed: (){
                           Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => First_page(
                  isRecovoring: false,
                )));
                        }, 
                        child: Text("Create"))
                    ],
                  ),
                  ],

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}