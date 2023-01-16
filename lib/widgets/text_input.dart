import 'package:crowdpad_assignment/utils/colors_constant.dart';
import 'package:flutter/material.dart';


class TextInputField extends StatelessWidget {
  // final - Jab Aapko Pata ho ki ye ab change nahi hoga - const But Widgets/Methods Ke Liye
  final TextEditingController controller;
  final  IconData myIcon;
  final String myLabelText;
  final bool toHide;
  TextInputField({Key? key ,
  required this.controller,
    required this.myIcon,
    required this.myLabelText,
    this.toHide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: toHide,
      controller: controller,
      style: TextStyle(color: Colors.white),
      cursorColor: AppColors.neonPinkColor,
      decoration: InputDecoration(
        icon: Icon(myIcon, color: AppColors.neonPinkColor,),

        labelText: myLabelText,
        labelStyle: TextStyle(
          color: AppColors.neonPinkColor
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.white,
            )),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          color: Colors.white,
        ), ),

      ),


    );
  }
}
