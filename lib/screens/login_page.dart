import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/reviewer/Reviewer_pages/home_page.dart';
import 'package:integrity/screens/reviewer/auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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

  bool modal=false;

  Future<void> userSignIn() async {
    await for (var snapshot in _fireStore.collection('users').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data()['phone']);
        if(message.data()['phone']==countryCode+PhoneController.text && message.data()['password']== PasswordController.text) {
               
           if(message.data()["usertype"]=="reviewer")  {
           Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Reviewer_Home_Page()));
           }   else {


           }
            
        } else{
          print("user name and password dont match");
        }
        }}
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
                                countryCode="+" +country.dialCode;
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
                   
                    child: TextField(
                    controller: PasswordController,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey),
                    onChanged: (value) {
                      // password = value;
                      //Do something with the user input.
                    },
                    decoration: InputDecoration(
                      
                                hintStyle: TextStyle(color: Colors.blueGrey),
                                hintText: 'Enter your password.',
                                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                              )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Forgot password'),
                      TextButton(
                        onPressed: (){}, 
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
                           Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()));
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