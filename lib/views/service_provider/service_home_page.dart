import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:integrity/controllers/category_controller.dart';
import 'package:integrity/views/createService.dart';

class Provider_Home_Page extends StatefulWidget {
  Provider_Home_Page({Key? key}) : super(key: key);

  @override
  State<Provider_Home_Page> createState() => Provider__Home_PageState();
}

class Provider__Home_PageState extends State<Provider_Home_Page> {

  Widget categoriesList()
  {
    return GetX<CategoryController>(
      init: Get.put(CategoryController()),
      builder: (cController){
        return cController.categories.length>0?
        ListView.builder(
            itemCount: cController.categories.length,
            itemBuilder: (BuildContext context, int index){
              return categoryItem(cController,index);
            })
            :Center(child: CircularProgressIndicator(),);
      },
    );
  }
  Widget categoryItem(CategoryController controller,int index)
  {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex:1,child: Icon(Icons.home_outlined,color: Colors.blue,)),
            Expanded(flex:5,child: Text(controller.categories[index].name)),
            Expanded(flex:1,child: 
             IconButton(onPressed:(){createService(controller.categories[index].name);}, icon: Icon(Icons.add,color: Colors.grey.shade400,))
            )
          ],
        ),
        Divider(color: Colors.grey.shade500,),
        SizedBox(height: 10,)
      ],
    );

  }

  createService(String categoryName) async
  {

   showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>CreateService(categoryName)
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body:SafeArea(
        child:Container(
          margin: EdgeInsets.only(left: 15,right: 10,top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded( flex: 6, child: Text('Categories',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.blueGrey.shade700),)),
                  Expanded( flex: 1, child: Icon(Icons.person_outline)),
                  Expanded( flex: 1,child: Icon(Icons.add_alert_outlined))
                ],
              ),
              SizedBox(height: 30,),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Search Service",
                    fillColor: Colors.grey.shade100),
                onTap: (){

                },
              ),
              SizedBox(height: 15,),
              Flexible(
                  child:categoriesList()
                  )
            ],
          ),
        ) ,
      )
      );
  }
}