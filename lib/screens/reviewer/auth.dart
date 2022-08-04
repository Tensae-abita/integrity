import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/reviewer/verify_otp.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    GlobalKey<FormState> _formKey = GlobalKey();
    TextEditingController PhoneController=TextEditingController();
    var countryCode ="+251";
    var PhoneNUmber="";
    var verId='';

    Future<void> verifyPhone(var number) async{
     
setState(() {
   modal=true;
});
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        // timeout: const Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential credential)async{
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) => print('logged in'));
          modal=false;
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
          // screenState = 1;
          modal=false;
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Verify_otp(
                  phoneNumber: PhoneController,
                  countryCode: countryCode,
                  verId: verId,
                )),
              );
        });
      },
      codeAutoRetrievalTimeout: (String verificationId){

      });
    }
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