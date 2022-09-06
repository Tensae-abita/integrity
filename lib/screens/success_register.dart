import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrity/main.dart';
import 'package:integrity/screens/login_page.dart';
import 'package:integrity/screens/reviewer/Reviewer_pages/home_page.dart';
import 'package:integrity/views/service_provider/service_home_page.dart';


class Success extends StatelessWidget {
  var userType;
  bool isRecovering;
   Success({
   required this.isRecovering,
   required this.userType
  });

  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Center(
                  child: Column(
                    children:  [
                      Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  width: MediaQuery.of(context).size.width*0.4,
                  child: Image.asset('assets/images/success.png'),

                ),
                       Text(!isRecovering?"Profile Setup":"Password Changed".toString(),style: TextStyle(
                                fontSize: 30,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400
                               ),),
                      const Text("Successfuly",style: TextStyle(
                                fontSize: 30,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400
                               ),),         
                    ],
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                 
                       decoration: const BoxDecoration(
                         borderRadius: BorderRadius.all(Radius.circular(10)),
                             color: Colors.blueAccent,
                       ),
                       width: MediaQuery.of(context).size.width*0.7,
                       height: 60,
                         child: TextButton(
                          
                          onPressed: (){
                            !isRecovering?
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => userType=="Reviewer"? Reviewer_Home_Page():Provider_Home_Page()
                                 )
                              ):
                               Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LogIn_page()
                                 )
                              );
                          }, child: Text(isRecovering?"Sign in":"EXPLORE NOW",style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),)),
                       ),
                  ),
              ],
            ),
          ),
        ),
      )
    );
  }
}