import 'dart:io';

import 'package:crowdpad_assignment/auth/data/api/auth_api_handler.dart';
import 'package:crowdpad_assignment/home_page/presentation/home_page_index.dart';
import 'package:crowdpad_assignment/widgets/text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


// TODO TODO TODO IMPORTANT UI SUDHARO
class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController =  TextEditingController();

  final TextEditingController _usernameController =  TextEditingController();

  final TextEditingController _setPasswordController =  TextEditingController();

  final TextEditingController _confirmPasswordController =  TextEditingController();

  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 100),
          alignment: Alignment.center,
          //const - Constant - Value - String , Int  - Fix Rahega  - Use Karna
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25,),
              InkWell(
                onTap: () {
                  ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
                    if(image == null) return;
                    setState(() {
                      _selectedImage = File("${image.path}");
                    });
                  });

                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                      NetworkImage("https://st3.depositphotos.com/1767687/16607/v/450/depositphotos_166074422-stock-illustration-default-avatar-profile-icon-grey.jpg"),
                      radius: 60,
                      child: _selectedImage == null ? null : Image.file(_selectedImage!),
                    ),
                    Positioned( bottom: 0, right: 0, child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Icon(Icons.edit , size: 20,color: Colors.black,)))
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _emailController,
                  myLabelText: "Email",
                  myIcon: Icons.email,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _setPasswordController,
                  myLabelText: "Set Password",
                  myIcon: Icons.lock,
                  toHide: true,
                ),
              ),

              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _confirmPasswordController,
                  myLabelText: "Confirm Password",
                  myIcon: Icons.lock,
                  toHide: true,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _usernameController,
                  myLabelText: "Username",
                  myIcon: Icons.person,
                ),
              ),
              SizedBox(height: 30,),
              ElevatedButton(onPressed: (){

                AuthApiHandler.signUpUser(_usernameController.text, _emailController.text, _setPasswordController.text, _selectedImage).then((value) {
                  if(value == true){
                    Navigator.push(context, CupertinoPageRoute(builder: (_){
                      return MyHomePage();
                    }));
                  }

                });

             // AuthController.instance.SignUp(_usernameController.text, _emailController.text,_setpasswordController.text, AuthController.instance.proimg);
              }, child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50 , vertical: 10),

                  child: Text("Sign Up")))
            ],
          ),

        ),
      ),
    );
  }
}
