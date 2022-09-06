import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/reviewer/Reviewer_pages/home_page.dart';
// import 'package:integrity/screens/reviewer/success_register.dart';
import 'package:integrity/screens/success_register.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class EnterPassword extends StatefulWidget {
    var phoneNumber;
    var userType;
    var userId;
    var isRecovering=false;
    var country;
  EnterPassword({
    required this.isRecovering,
    required this.userType,
    this.phoneNumber,
    this.userId,
    this.country
  });

  @override
  State<EnterPassword> createState() => _EnterPasswordState();
}

class _EnterPasswordState extends State<EnterPassword> {
  
  bool modal=false;
  TextEditingController PasswordController=TextEditingController();
  final _fireStore = FirebaseFirestore.instance;
  var whatUser='';
  
  bool errorVisible=false;
 
  void recoverPassword()async{
var bytes = utf8.encode(PasswordController.text); // data being hashed

  var digest = sha256.convert(bytes);
    setState(() {
                    modal=true;
                  });
  await  _fireStore.collection('users').where('phone', isEqualTo:widget.phoneNumber,)
          .get()
          .then((value)async { if(value.size > 0 ){
            
                 for(var data in value.docs){
                 if(value.size==1){
                whatUser= data.reference.id;
                 }else{
                  if(data.data()['usertype']==widget.userType){
                     whatUser= data.reference.id;
                     print("user is ${whatUser}");
                  }
                 }
              }
               setState(() {
                    modal=false;
                  });

          }},

           
          );
  
                   try {
                        await _fireStore.collection('users').doc(whatUser).update({
                            'password':digest.toString()
                        }).then((value) => 
                           Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Success(
                  userType:widget.userType,
                  isRecovering: widget.isRecovering?true:false,
                )))
                        );

                      } catch (e) {
                        print(e);
                      }

  }
 
  void setPassword()async{
// _fireStore.collection('users').add();
 var bytes = utf8.encode(PasswordController.text.toString()); // data being hashed

   var digest = sha256.convert(bytes);

   await _fireStore.collection('users').add(
     {'phone': widget.phoneNumber,
       "userid":widget.userId,
       "userCountry":widget.country,
       "password":digest.toString(),
       "usertype":widget.userType,
     }).then((value) => {
       if(value.id.length > 0)
         Navigator.pushReplacement(
         context,
         MaterialPageRoute(builder: (context) => Success(
         userType:widget.userType,
         isRecovering: widget.isRecovering?true:false,
         )))
   }).onError((error, stackTrace) => {
   });

   /*await  _fireStore.collection('users') .where('phone', isEqualTo:widget.phoneNumber,)
          .get()
          .then((value) async {
            if(value.size > 0 )
            {
            for(var data in value.docs){
              data.data()['usertype'];
              // print(PasswordController.text)  ;
              if(digest.toString()==data.data()['password']){
                print('match');
                  setState(() {
                    modal=false;
                    errorVisible=true;
                  });
                

              }
              else {
                 setState(() {
                    modal=true;
                  });
                   try {
                        await _fireStore.collection('users').add(
                            {'phone': widget.phoneNumber,
                             "username":'',
                             "password":digest.toString(),
                             "usertype":widget.userType,
                             });
                        print('done');

                        Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Success(
                  userType:widget.userType,
                  isRecovering: widget.isRecovering?true:false,
                )));

                      } catch (e) {
                        print(e);
                      }

              // showSnackBarText('UserName and Password Do not match');

              }
            }}
            else{
               try {
                        await _fireStore.collection('users').add(
                            {'phone': widget.phoneNumber,
                             "username":'',
                             "password":digest.toString(),
                             "usertype":widget.userType,
                             });
                        print('done');

                        Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Success(
                  userType:widget.userType,
                  isRecovering: widget.isRecovering?true:false,
                )));

                      } catch (e) {
                        print(e);
                      }

            }
            });
           try {
                        await _fireStore.collection('users').add(
                            {'phone': widget.phoneNumber,
                             "username":'',
                             "password":digest.toString(),
                             "usertype":widget.userType,
                             });
                        print('done');

                        Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Success(
                  userType:widget.userType,
                  isRecovering: widget.isRecovering?true:false,
                )));

                      } catch (e) {
                        print(e);
                      }*/

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
                    Text('Enter Password',style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[900]
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child:FancyPasswordField(
                        controller: PasswordController,
                validationRules: {
                    DigitValidationRule(),
                    // UppercaseValidationRule(),
                    // LowercaseValidationRule(),
                    SpecialCharacterValidationRule(),
                    MinCharactersValidationRule(6),
                    // MaxCharactersValidationRule(12),
                },
                
                validationRuleBuilder: (rules, value) {
                  if (value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: rules
                        .map(
                          (rule) => rule.validate(value)
                              ? Row(
                                  children: [
                                    const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                        rule.name,
                                        style: const TextStyle(
                                            color: Colors.green,
                                        ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                        rule.name,
                                        style: const TextStyle(
                                            color: Colors.red,
                                        ),
                                    ),
                                  ],
                                ),
                        )
                        .toList(),
                  );
                },
              ),

                    ),
                      Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: Visibility(
                        visible: errorVisible,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Column(
                                children: [
                                  Text("can't use the same password for",style: TextStyle(color: Colors.red),),
                                   Text("diferent account ",
                              style: TextStyle(color: Colors.red),),
                                ],
                              ),
                             
                           
                          ],
                        ),
                      ),
                    ),
                  //     Container(
                  //   width: MediaQuery.of(context).size.width*0.7,
                   
                  //   child: TextField(
                  //   controller: PasswordController,  
                  //   obscureText: true,
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(color: Colors.blueGrey),
                  //   onChanged: (value) {
                  //     // password = value;
                  //     //Do something with the user input.
                  //   },
                  //   decoration: InputDecoration(
                      
                  //               hintStyle: TextStyle(color: Colors.blueGrey),
                  //               hintText: 'Enter your password.',
                  //               contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  //               border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //               ),
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  //                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  //                 borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //               ),
                  //             )),
                  // ),
                    // Text('Enter Mobile Number we will',style: TextStyle(
                     
                    // ),),
                    // SizedBox(height:5),
                    // Text('Send you OTP'),
                    SizedBox(height:20),
                    
                 
                

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
                            widget.isRecovering?  recoverPassword(): setPassword();
                             
                            //   // print(countryCode+PhoneController.text);
                            //     var val=_formKey.currentState?.validate();
                            //   if (val ==true){
                                
                                  
                            //     // verifyPhone(countryCode+PhoneController.text);
                            //  }
                            }, child: Text("SET PASSWORD",style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),)),
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