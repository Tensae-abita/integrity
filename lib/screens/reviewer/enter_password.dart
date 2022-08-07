import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EnterPassword extends StatefulWidget {
    var phoneNumber;
  
  EnterPassword({
    
    this.phoneNumber
  });

  @override
  State<EnterPassword> createState() => _EnterPasswordState();
}

class _EnterPasswordState extends State<EnterPassword> {
  bool modal=false;
  TextEditingController PasswordController=TextEditingController();
  final _fireStore = FirebaseFirestore.instance;

 
  void setPassword()async{
// _fireStore.collection('users').add();

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
                              setPassword();
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