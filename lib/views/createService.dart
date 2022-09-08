import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:integrity/controllers/serviceController.dart';
import 'package:integrity/models/serviceModel.dart';
import 'package:intl/intl.dart';

class CreateService extends StatefulWidget {
  final String category;
  CreateService(this.category);
  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  final _formKey = GlobalKey<FormState>();
  final box=GetStorage();
  String? userId;
  TextEditingController serviceNameController=TextEditingController();
  TextEditingController serviceCategoryController=TextEditingController();
  TextEditingController serviceDescriptionController=TextEditingController();
  TextEditingController pinCodeController=TextEditingController();
  TextEditingController webLinkController=TextEditingController();
  TextEditingController zoomLinkController=TextEditingController();
  TextEditingController watsAppController=TextEditingController();
  TextEditingController upiController=TextEditingController();
  TextEditingController telegramController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController startDayController=TextEditingController();
  TextEditingController endDayController=TextEditingController();
  TextEditingController startTimeController=TextEditingController();
  TextEditingController endTimeController=TextEditingController();

  bool saving=false;
  double lat=0,long=0;
  double fromTime=0,toTime=0;
  late String countryValue;
  late String stateValue;
  late String cityValue;
  List<String> days=['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

  List<String> searchSuggestion(String query)=>
      List.of(days).where((element) {
            final numberLower=element.toLowerCase();
            final queryLower=query.toLowerCase();
            return numberLower.contains(queryLower);
      }).toList();

 Future<TimeOfDay> _selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();

    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
     return selectedTime;
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(forceAndroidLocationManager: true)
        .then((Position position) {
      setState((){
        lat=position.latitude;
        long=position.longitude;} );

    }).catchError((e) {
      debugPrint(e);
    });
  }

 addService()
 {
   if (!_formKey.currentState!.validate()) {
     setState(() {
       saving = false;
     });
   }
   else
     {
       ServiceModel model=ServiceModel(userId!,serviceNameController.text, widget.category, serviceDescriptionController.text,
           startTimeController.text, endTimeController.text, startDayController.text, endDayController.text,
       countryValue,stateValue,cityValue,pinCodeController.text,lat.toString(),long.toString(),emailController.text,
           upiController.text,watsAppController.text
       ,telegramController.text,zoomLinkController.text,webLinkController.text);
       ServiceController controller=Get.put(ServiceController());
       controller.saveService(model);
       saving=false;
       Get.back();
     }
 }


 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(box!=null)
      {
        userId=box.read('id');
        FirebaseFirestore.instance.collection('users').where('userid',isEqualTo:userId).get().then((value) =>
        {
          for(var data in value.docs)
            {
              countryValue=data.data()['userCountry'],
            }
        });
      }
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) =>
           Form(
             key: _formKey,
             child: Container(
                   margin: EdgeInsets.only(left: 20,right: 20),
                   height:MediaQuery.of(context).size.height/1.5,
                   child: SingleChildScrollView(
                     child: Column(
                     children: [
                       Row(
                         children: [
                           SizedBox(width: 10,),
                           Expanded(flex: 4,
                             child: Text('Create Service',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.cyan.shade800),),
                           ),
                           Expanded(flex: 1,
                             child: IconButton(icon: Icon(Icons.clear),
                               onPressed: (){
                                 Navigator.pop(context);
                               },
                             ),
                           )
                         ],
                       ),
                       TextFormField(
                         controller: serviceNameController,
                         style:  TextStyle(color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type Service name",
                               fillColor: Colors.grey.shade200),
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter service name';
                           }
                           return null;
                         },
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         readOnly: true,
                         style:  TextStyle(color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey[800],fontSize: 14),
                             hintText: widget.category,
                             fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller: serviceDescriptionController,
                         style:  TextStyle(color: Colors.black87, fontSize: 16),
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter service description';
                           }
                           else if(value.length>500)
                             {
                               return 'description should be short';
                             }
                           return null;
                         },
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),
                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),
                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type short Description",
                             fillColor: Colors.grey.shade200),
                         maxLines: 5,
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       Container(
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey.shade200),
                         child: Column(
                           children: [
                             SizedBox(height: 10,),
                             Text('Availability Time'),
                             SizedBox(height: 10,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 SizedBox(width: 10,),
                                 Expanded(
                                   flex: 1,
                                   child:Container(
                                     height: 50,
                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                     child:Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Flexible(
                                             child: TextFormField(
                                             controller: startTimeController,
                                             readOnly: true,
                                             style:  TextStyle(color: Colors.black87, fontSize: 16),
                                             decoration: InputDecoration(
                                               enabledBorder: new OutlineInputBorder(
                                                 borderRadius: new BorderRadius.circular(15.0),
                                                 borderSide:  BorderSide(color:  Colors.white ),
                                               ),
                                               focusedBorder: new OutlineInputBorder(
                                                 borderRadius: new BorderRadius.circular(15.0),
                                                 borderSide:  BorderSide(color:  Colors.white ),
                                               ),
                                               filled: true,
                                               hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                               hintText: "From",
                                               fillColor: Colors.white),
                                             validator: (value) {
                                                 if (value == null || value.isEmpty) {
                                                   return 'Please select a Time';
                                                 }
                                                 return null;
                                               },
                                           onTap: (){

                                           },
                                         )),
                                         IconButton(icon: Icon(Icons.access_time,color: Colors.blue,),
                                           onPressed: () async{
                                             TimeOfDay t=await _selectTime(this.context);
                                             setState((){
                                               fromTime=t.hour.toDouble()+(t.minute.toDouble() / 60);
                                               startTimeController.text=t.format(this.context);
                                             });
                                           },
                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10,),
                                 Expanded(
                                   flex: 1,
                                   child:Container(
                                     height: 50,
                                   //  padding: EdgeInsets.only(left: 8,right: 8),
                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                     child:Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Flexible(
                                             child: TextFormField(
                                               controller: endTimeController,
                                               readOnly: true,
                                               style:  TextStyle(
                                                   color: Colors.black87, fontSize: 16),
                                               decoration: InputDecoration(
                                                   enabledBorder: new OutlineInputBorder(
                                                     borderRadius: new BorderRadius.circular(15.0),
                                                     borderSide:  BorderSide(color:  Colors.white ),
                                                   ),
                                                   focusedBorder: new OutlineInputBorder(
                                                     borderRadius: new BorderRadius.circular(15.0),
                                                     borderSide:  BorderSide(color:  Colors.white ),
                                                   ),
                                                   filled: true,
                                                   hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                                                   hintText: "To",
                                                   fillColor: Colors.white),
                                               validator: (value) {
                                                 if (value == null || value.isEmpty) {
                                                   return 'Please select a Time';
                                                 }
                                                 else if(fromTime>=toTime)
                                                   {
                                                     return 'Please change the end time';
                                                   }
                                                 return null;
                                               },
                                               onTap: (){

                                               },
                                             )),
                                         IconButton(icon: Icon(Icons.access_time,color: Colors.blue,),
                                           onPressed: () async{
                                             TimeOfDay t=await _selectTime(this.context);
                                             setState((){
                                               toTime=t.hour.toDouble()+(t.minute.toDouble() / 60);
                                               endTimeController.text=t.format(context);
                                             });
                                           },
                                         )
                                       ],
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10,),
                               ],
                             ),
                             SizedBox(height: 10,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 SizedBox(width: 10,),
                                 Expanded(
                                     flex: 1,
                                     child:TypeAheadField(
                                       suggestionsCallback :(pattern) async {
                                         return await searchSuggestion(pattern);
                                       },
                                       onSuggestionSelected: (String day){
                                         setState((){
                                           startDayController.text=day;
                                         });
                                       },
                                       textFieldConfiguration: TextFieldConfiguration(
                                           controller: startDayController,
                                           style:  TextStyle(color: Colors.black87, fontSize: 14),
                                           decoration: InputDecoration(
                                               focusedBorder: new OutlineInputBorder(
                                                 borderRadius: new BorderRadius.circular(15.0),
                                                 borderSide:  BorderSide(color:  Colors.white ),
                                               ),
                                               enabledBorder: new OutlineInputBorder(
                                                 borderRadius: new BorderRadius.circular(15.0),
                                                 borderSide:  BorderSide(color:  Colors.white ),
                                               ),
                                               hintText: 'From (day)',
                                               hintStyle: TextStyle(color: Colors.grey.shade500),
                                               filled: true,
                                               fillColor: Colors.white
                                           ),

                                       ),
                                       itemBuilder: (context,String day){
                                         return ListTile(title: Text(day),);
                                       },
                                     ) ),
                                 SizedBox(width: 10,),
                                 Expanded(
                                     flex: 1,
                                     child:TypeAheadField(
                                       suggestionsCallback :(pattern) async {
                                         return await searchSuggestion(pattern);
                                       },
                                       onSuggestionSelected: (String day){
                                         setState((){
                                           endDayController.text=day;
                                         });
                                       },
                                       textFieldConfiguration: TextFieldConfiguration(
                                           controller: endDayController,
                                           style:  TextStyle(
                                               color: Colors.black87, fontSize: 14),
                                           decoration: InputDecoration(
                                               focusedBorder: new OutlineInputBorder(
                                                 borderRadius: new BorderRadius.circular(15.0),
                                                 borderSide:  BorderSide(color:  Colors.white ),
                                               ),
                                               enabledBorder: new OutlineInputBorder(
                                                 borderRadius: new BorderRadius.circular(15.0),
                                                 borderSide:  BorderSide(color:  Colors.white ),
                                               ),
                                               hintText: 'To (day)',
                                               hintStyle: TextStyle(color: Colors.grey.shade500),
                                               filled: true,
                                               fillColor: Colors.white
                                           )
                                       ),
                                       itemBuilder: (context,String day){
                                         return ListTile(title: Text(day),);
                                       },
                                     ) ),
                                 SizedBox(width: 10,),
                               ],
                             ),
                             SizedBox(height: 10,),
                           ],
                         ),
                       ),
                       SizedBox(height: 20,),

                       SelectState(
                         onCountryChanged: (value) {
                           setState(() {
                            countryValue= value;
                           });
                         },
                         onStateChanged:(value) {
                           setState(() {
                            stateValue = value;
                           });
                         },
                         onCityChanged:(value) {
                           setState(() {
                             cityValue = value;
                           });
                         },

                       ),

                       SizedBox(height: 20,),
                       TextFormField(
                         controller:pinCodeController ,
                         style:  TextStyle(
                             color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type Pin code",
                             fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller:watsAppController ,
                         style:  TextStyle(
                             color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type Your business Watsapp",
                             fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller:emailController ,
                         style:  TextStyle(
                             color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type email",
                             fillColor: Colors.grey.shade200),
                         validator: (val) {
                           bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.toString());

                           if (val == null || val.isEmpty) {
                             return 'Please write an email address';
                           }
                           else if(!emailValid)
                             {
                               return 'not a valid email address';
                             }
                           return null;
                         },
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller:upiController,
                         style:  TextStyle(
                             color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Upi link",
                             fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller:telegramController,
                         style:  TextStyle(
                             color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type telegram",
                             fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller:zoomLinkController,
                         style:  TextStyle(
                             color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type Zoom Link",
                             fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller:webLinkController ,
                         style:  TextStyle(
                             color: Colors.black87, fontSize: 16),
                         decoration: InputDecoration(
                             enabledBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.grey.shade200 ),

                             ),
                             focusedBorder: new OutlineInputBorder(
                               borderRadius: new BorderRadius.circular(15.0),
                               borderSide:  BorderSide(color:  Colors.cyan.shade700 ),

                             ),
                             filled: true,
                             hintStyle: TextStyle(color: Colors.grey.shade500,fontSize: 14),
                             hintText: "Type your web address",
                             fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       saving?Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                           child:Center(child: CircularProgressIndicator(),)):
                       Container(
                         width: MediaQuery.of(context).size.width,
                         child: Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                             child:TextButton(onPressed: (){
                               setState((){
                                 saving=true;
                               });
                               addService();
                             },
                                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),
                                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                         RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(15.0),
                                             side: BorderSide(color: Colors.blue)
                                         )
                                     ),
                                     padding: MaterialStateProperty.all(EdgeInsets.only(top: 20,bottom: 20))
                                 ),
                                 child: Text('CREATE NOW',style: TextStyle(color: Colors.white),)
                             )),
                       ),
                       SizedBox(height: 20,)
                     ],
                   )
               )))
    );
  }

}