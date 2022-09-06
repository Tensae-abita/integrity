

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/first_page.dart';
import 'package:integrity/screens/login_page.dart';
// import 'package:integrity/screens/reviewer/verify_otp.dart';
import 'package:integrity/screens/verify_otp.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Register extends StatefulWidget {
  String userType;
 
  Register({
   
    required this.userType
  });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    GlobalKey<FormState> _formKey = GlobalKey();
    TextEditingController PhoneController=TextEditingController();
  final _fireStore = FirebaseFirestore.instance;

    var countryCode ="+251";
    var Country='ET';
    var PhoneNUmber="";
    var verId='';
    bool errorVisible=false;
   bool result = true;
  checkConn()async{
   result = await InternetConnectionChecker().hasConnection;
   return result;
   }

   

    Future<void> verifyPhone(var number) async{
    await checkConn();

    if(result==false){
    showSnackBarText('YOU HAVE NO INTERNET CONNECTION');
    }
      
      setState(() {
            modal=true;
            errorVisible=false;
          });
      await  _fireStore.collection('users') .where('phone', isEqualTo: number)
          .get()
          .then((value) async {
            if(value.size > 0 )
            {
           if(value.size==1){
             for(var data in value.docs){
              print(data.data()['usertype']);
              if(widget.userType==data.data()['usertype']){
                 setState(() {
                  modal=false;
                  errorVisible=true;
                });
                if(result==true){
                showSnackBarText('can not have multiple accounts as ${widget.userType}');

                }
                
                // print('match');
                //   Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => Reviewer_Home_Page()));
              }else if(widget.userType!=data.data()['usertype']){
               
              auth(number);

              }}
           }
           else if(value.size>1){
             setState(() {
                  modal=false;
                  errorVisible=true;
                });
                if(result==true){
                showSnackBarText('can not have multiple accounts as ${widget.userType}');

                }
           }
          
          
          }
            else{
            auth(number);
          }
          
          });
        
        
       
        
      }
@override
void initState() {
  super.initState();
  checkConn();
}

      Future<void> auth(var number)async{
           await   FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        // timeout: const Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential credential)async{
          // await FirebaseAuth.instance.signInWithCredential(credential).then((value) => print('logged in'));
          modal=false;
        }, 
        verificationFailed: (FirebaseAuthException e){
          setState(() {
              modal=false;
            });
           if(result==true){
          showSnackBarText("can't send code check if you have typed correct number:"+e.toString());

           }

        }, 
        codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        setState(() {
          // screenState = 1;
          modal=false;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Verify_otp(
                  phoneNumber: PhoneController,
                  countryCode: countryCode,
                  verId: verId,
                  userType: widget.userType,
                  isRecovering: false,
                  country: Country,
                )),
              );
        });
      },
      codeAutoRetrievalTimeout: (String verificationId){

      });
      }
    
          
      // await FirebaseAuth.instance.verifyPhoneNumber(
      //   phoneNumber: number,
      //   // timeout: const Duration(seconds: 20),
      //   verificationCompleted: (PhoneAuthCredential credential)async{
      //     // await FirebaseAuth.instance.signInWithCredential(credential).then((value) => print('logged in'));
      //     modal=false;
      //   }, 
      //   verificationFailed: (FirebaseAuthException e){
      //     setState(() {
      //         modal=false;
      //       });
           
      //     showSnackBarText("can't send code check if you have typed correct number");

      //   }, 
      //   codeSent: (String verificationId, int? resendToken) {
      //   verId = verificationId;
      //   setState(() {
      //     // screenState = 1;
      //     modal=false;
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => Verify_otp(
      //             phoneNumber: PhoneController,
      //             countryCode: countryCode,
      //             verId: verId,
      //           )),
      //         );
      //   });
      // },
      // codeAutoRetrievalTimeout: (String verificationId){

      // });
    
    bool modal=false;

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
          appBar: AppBar(
            leading: TextButton(
              
              onPressed: (){  
                 Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => First_page(
              isRecovoring: false,
            )),
              );
              },
               child: Icon(Icons.arrow_back_sharp,color: Colors.white,),),
          ),
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
                    Text('Enter Mobile No',style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[900]
                    ),),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Enter Mobile Number we will',style: TextStyle(
                     
                    ),),
                    SizedBox(height:5),
                    Text('Send you OTP'),
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
                            initialCountryCode: Country,
                            initialValue: countryCode,
                            onCountryChanged: (country){
                              setState(() {
                                Country=country.code;

                                print(Country);
                                countryCode="+" +country.dialCode;
                                print(countryCode);
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
                      child: Visibility(
                        visible: errorVisible,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Column(
                                children: [
                                  Text("Acount already exists ",style: TextStyle(color: Colors.red),),
                                   Text(" with this number",
                              style: TextStyle(color: Colors.red),),
                                ],
                              ),
                             
                            TextButton(
                              onPressed: (){
                                  Navigator.push(
                               context,
                                MaterialPageRoute(builder: (context) => LogIn_page()),
                              ); 
                              },
                               child: Text('Log In'))
                          ],
                        ),
                      ),
                    ),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('I already have an account'),
                      TextButton(
                        onPressed: (){
                           Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn_page()));
                        }, 
                        child: Text("Log In"))
                    ],
                  ),
                    SizedBox(
                      height: 40,
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
                              // print(countryCode+PhoneController.text);
                                var val=_formKey.currentState?.validate();
                              if (val ==true){
                                
                                  
                                verifyPhone(countryCode+PhoneController.text);
                             }
                            }, child: Text("SEND OTP",style: TextStyle(
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