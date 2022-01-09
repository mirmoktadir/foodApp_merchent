 import 'package:flutter/material.dart';
import 'package:foodbank_marchantise_app/utils/font_size.dart';
import 'package:foodbank_marchantise_app/views/order_details.dart';
import 'package:get/get.dart';


class Notifications extends StatefulWidget {
   const Notifications({Key? key}) : super(key: key);

   @override
   _NotificationsState createState() => _NotificationsState();
 }

 class _NotificationsState extends State<Notifications> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(

         title: Text("Notifications",
           style: TextStyle(
               fontWeight: FontWeight.w900,
               fontSize: FontSize.xLarge,
               color: Colors.white
           ),),
         backgroundColor: Colors.black,
         centerTitle: true,
         elevation: 0.0,

       ),
       body: ListView.builder(
         itemCount: 10,
         itemBuilder: (context, index) {
           return Container( padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2.5),
             child: Column(
               children: [
                 ListTile(
                   title: Row(
                     children: [
                       Text("Order ",
                         style: TextStyle(
                         //  fontWeight: FontWeight.w500
                       ),),
                       Text("#14316531",
                         style: TextStyle(
                         fontWeight: FontWeight.w500
                       ),),

                       Text("is assigned to you",
                         style: TextStyle(
                           //  fontWeight: FontWeight.w500
                         ),),
                     ],
                   ),
                   subtitle: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("50 minutes ago",
                         style: TextStyle(
                             fontWeight: FontWeight.w300
                         ),),

                       TextButton(onPressed: (){Get.to(()=>Order_details());}, child: Text("view"))

                     ],
                   ),




                 ),

                 Divider()
               ],
             ),
           );
         },
       ),
     );
   }
 }
