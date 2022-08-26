import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';


class Reviewer_Home_Page extends StatefulWidget {
  Reviewer_Home_Page({Key? key}) : super(key: key);

  @override
  State<Reviewer_Home_Page> createState() => Reviewer__Home_PageState();
}

class Reviewer__Home_PageState extends State<Reviewer_Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Categories",style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 30,),),
                Row(
                  children: [
                    Icon(Icons.person_outline,color: Colors.grey[600],),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.notifications_none_outlined,color: Colors.grey[600],),
                      SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.file_open_outlined,color: Colors.grey[600],),

                  ],
                ),
                  
              ],
            ),
          ),
        ),
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Color.fromARGB(255, 149, 153, 161).withOpacity(0.32),
                        ),
                        color: Colors.grey[100],
                      ),
                      child: const TextField(
                        // onChanged: (value) => ,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 111, 112, 114),
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                          hintText: "Search Service",
                          hintStyle: TextStyle(color: Color.fromARGB(255, 90, 90, 90)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                          expandable(
                            icon: Icons.hotel,
                            service: 'Hotels',
                            name: 'Swimming pool',
                            star: '4',
                            reveiwNumber: '12',
                            isExpired: 'Expired on 22 jun 2018',
                            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                          ),
                           expandable(
                            icon: Icons.car_repair,
                            service: 'Car',
                            name: 'Car Repair',
                            star: '3',
                            reveiwNumber: '10',
                            isExpired: '',  
                            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                          ),
                           expandable(
                            icon: Icons.movie,
                            service: 'Entertainment',
                            name: 'Car Repair',
                            star: '3',
                            reveiwNumber: '10',
                            isExpired: '',  
                            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                          )
                       ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
   
      ),
    );
  }
}






class expandable extends StatelessWidget {
  var service;
  var icon;
  var name;
  var star;
  var reveiwNumber;
  var isExpired;
  var description;
  
   expandable({
    Key? key,
    this.service,
    this.icon,
    this.name,
    this.star,
    this.reveiwNumber,
    this.isExpired,
    this.description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
  //  decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(5.0),
              //   // color: Colors.white,
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey,
              //       offset: Offset(0.0, 1.0), //(x,y)
              //       blurRadius: 6.0,
              //     ),
              //   ],
              // ),
      child: ExpandablePanel(
        
        header: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
                  textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(icon,size: 40,color: Colors.blueAccent,),
              const SizedBox(
                width: 10,
              ),
              Text(service,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500
                ),)
            ]
        ),
        collapsed: const Text('', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
        expanded: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              // height: MediaQuery.of(context).size.height*0.12,
              // width: MediaQuery.of(context).size.width*0.85,
               decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color.fromARGB(255, 149, 153, 161).withOpacity(0.32),
            ),
             color: Colors.grey[100],
          ),
             
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
      Text(name,style: const TextStyle(
        color: Colors.black,
        fontSize: 15
      ),
      
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(star),
            const SizedBox(
            width: 5,
          ), 
          Icon(Icons.star,color: Colors.yellow,),
           const SizedBox(
            width: 5,
          ),  
          Text('|',style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(
            width: 5,
          ),
          Text('${reveiwNumber} Reviews')
        ],
      )
                      ]
                    ) ,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 0),
        child: Text(isExpired,style: TextStyle(
          color: Colors.grey[400]
        ),),
      ),
                      ],
                    ),
                    Container(
                       decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
            ),
             color: Colors.white,
          ),
                       child: Padding(
       padding: const EdgeInsets.all(13.0),
       child: Text(
        
        description, 
        style: TextStyle(
          color: Colors.grey[800],
          
        ),
        ),
                       ),     
                    )
                  ],
                ),
              ),
            ),
          ),
        )
       
      ),
    );
  }
}