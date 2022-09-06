import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  TextEditingController serviceNameController=TextEditingController();
  TextEditingController serviceCategoryController=TextEditingController();
  TextEditingController serviceDescriptionController=TextEditingController();

  String startTime='From';
  String endTime='To';
  String startDay='From';
  String endDay='To';
  bool saving=false;

 Future<String> _selectTime(BuildContext context) async {
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
     return selectedTime.format(context);
  }

 Future<String> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    return DateFormat('dd-MM-yy').format(selectedDate);
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
       ServiceModel model=ServiceModel(serviceNameController.text, widget.category, serviceDescriptionController.text, startTime, endTime, startDay, endDay);
       ServiceController controller=Get.put(ServiceController());
       controller.saveService(model);
       print(model);
       saving=false;
     }
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
                   child: ListView(
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
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter service name';
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
                             hintStyle: TextStyle(color: Colors.grey.shade500),
                             hintText: "Type Service name",
                               fillColor: Colors.grey.shade200),
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextField(
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
                             hintStyle: TextStyle(color: Colors.grey[800]),
                             hintText: widget.category,
                             fillColor: Colors.grey.shade200),
                         readOnly: true,
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       TextFormField(
                         controller: serviceDescriptionController,
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Please enter service description';
                           }
                           else if(value.length>50)
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
                             hintStyle: TextStyle(color: Colors.grey.shade500),
                             hintText: "Type short Description",
                             fillColor: Colors.grey.shade200),
                         maxLines: 5,
                         onTap: (){

                         },
                       ),
                       SizedBox(height: 20,),
                       Container(
                         //  height: 100,
                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.grey.shade200),
                         child: Column(
                           children: [
                             SizedBox(height: 10,),
                             Text('Availability Time'),
                             SizedBox(height: 10,),
                             Row(
                               children: [
                                 SizedBox(width: 10,),
                                 Expanded(
                                   flex: 1,
                                   child:Container(
                                     height: 50,
                                     padding: EdgeInsets.only(left: 8,right: 8),
                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                     child:Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         startTime=='From'?Text(startTime,style: TextStyle(color: Colors.grey.shade500),):
                                         Text(startTime),
                                         IconButton(icon: Icon(Icons.access_time,color: Colors.blue,),
                                           onPressed: () async{
                                             String t=await _selectTime(this.context);
                                             setState((){
                                               startTime=t;
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
                                     padding: EdgeInsets.only(left: 8,right: 8),
                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                     child:Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         endTime=='To'?Text(endTime,style: TextStyle(color: Colors.grey.shade500),):
                                         Text(endTime,style: TextStyle(color: Colors.grey.shade500),),
                                         IconButton(icon: Icon(Icons.access_time,color: Colors.blue,),
                                           onPressed: () async{
                                             String t=await _selectTime(this.context);
                                             setState((){
                                               endTime=t;
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
                               children: [
                                 SizedBox(width: 10,),
                                 Expanded(
                                     flex: 1,
                                     child:Container(
                                       height: 50,
                                       padding: EdgeInsets.only(left: 8,right: 8),
                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                       child:Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text(startDay),
                                           IconButton(icon: Icon(Icons.calendar_month,color: Colors.blue,),
                                             onPressed: () async{
                                               String t=await _selectDate(this.context);
                                               setState((){
                                                 startDay=t;
                                               });
                                             },
                                           )
                                         ],
                                       ) ,
                                     )
                                 ),
                                 SizedBox(width: 10,),
                                 Expanded(
                                     flex: 1,
                                     child:Container(
                                       height: 50,
                                       padding: EdgeInsets.only(left: 8,right: 8),
                                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Colors.white),
                                       child:Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Text(endDay),
                                           IconButton(icon: Icon(Icons.calendar_month,color: Colors.blue,),
                                             onPressed: () async{
                                               String t=await _selectDate(this.context);
                                               setState((){
                                                 endDay=t;
                                               });
                                             },
                                           )
                                         ],
                                       ) ,
                                     )
                                 ),
                                 SizedBox(width: 10,),
                               ],
                             ),
                             SizedBox(height: 10,),
                           ],
                         ),
                       ),
                       SizedBox(height: 20,),
                       saving?Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                           child:Center(child: CircularProgressIndicator(),)):
                       Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                       SizedBox(height: 20,)
                     ],
                   )
               ))
    );
  }

}