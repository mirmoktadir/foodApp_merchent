


import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Custom_Rounded_Button extends StatefulWidget {

  String button_text;


  Custom_Rounded_Button({Key? key,required this.button_text}) : super(key: key);



  @override
  _Custom_Rounded_ButtonState createState() => _Custom_Rounded_ButtonState();
}

class _Custom_Rounded_ButtonState extends State<Custom_Rounded_Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        //  elevation: 0.0,
        primary: Colors.black, // background
        onPrimary: Colors.white, // foreground
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // <-- Radius
        ),
      ),

      onPressed: () async {
        setState(() {

        });
      },
      child: Text(
        'Recieved',
        style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold

        ),
      ),
    );
  }
}
