import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrity/screens/reviewer/verify_otp.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        
                          decoration: InputDecoration(
                              labelText: 'Enter Mobile Number',
                              border: OutlineInputBorder(
                                
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {
                              print(phone.completeNumber);
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
                              var val=_formKey.currentState?.validate();
                            if (val ==true){
                             Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Verify_otp()),
                              ); }
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
    );
  }
}