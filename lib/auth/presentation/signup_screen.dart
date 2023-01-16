import 'dart:io';

import 'package:crowdpad_assignment/auth/business_logic/auth_page_cubit.dart';
import 'package:crowdpad_assignment/auth/data/api/auth_api_handler.dart';
import 'package:crowdpad_assignment/auth/presentation/login_screen.dart';
import 'package:crowdpad_assignment/home_page/presentation/home_page_index.dart';
import 'package:crowdpad_assignment/utils/app_utils.dart';
import 'package:crowdpad_assignment/utils/colors_constant.dart';
import 'package:crowdpad_assignment/widgets/gredient_widget.dart';
import 'package:crowdpad_assignment/widgets/outlined_button.dart';
import 'package:crowdpad_assignment/widgets/text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              alignment: Alignment.center,
              //const - Constant - Value - String , Int  - Fix Rahega  - Use Karna
              child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),


                  GradientWidget(
                      child: const Text("CROWDPAD", style: TextStyle(fontWeight: FontWeight.w900 ,fontSize: 25, letterSpacing: 5),),
                      gradient: AppGradients.neonPinkBlueGradient()
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  InkWell(
                    onTap: () {
                      ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
                        if(image == null) return;
                        setState(() {
                          _selectedImage = File(image.path);
                        });
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              gradient: AppGradients.neonPinkBlueGradient(),
                              shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _selectedImage == null ? const Icon(Icons.person, size: 50,) : Image.file(_selectedImage!, fit: BoxFit.cover,),
                        ),

                        Positioned( bottom: 0, right: 0, child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: Icon(Icons.edit , size: 20,color: AppColors.neonPinkColor,)))
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
                  MyOutlinedButton(
                    gradient: AppGradients.neonPinkBlueGradient(),
                      onPressed: (){

                        String email = _emailController.text;
                        String password = _setPasswordController.text;
                        String confirmPassword = _confirmPasswordController.text;
                        String username = _usernameController.text;
                        if(email.isEmpty || password.isEmpty || username.isEmpty || confirmPassword.isEmpty || password != confirmPassword || !AppUtils.isEmailCorrect(email)){
                          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Please fill all the details correctly!")));
                          return;
                        }

                        if(_selectedImage == null){
                          ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Please select image!")));
                          return;
                        }

                        BlocProvider.of<AuthPageCubit>(context).signUp(username, email, password, _selectedImage!);


                      },
                      child:  Container(
                          padding: EdgeInsets.symmetric(horizontal: 50 , vertical: 10),

                          child: GradientWidget(
                              gradient: AppGradients.neonPinkBlueGradient(),

                              child: Text("Sign Up",))
                      )
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a member ?   ", style: TextStyle(color: Colors.white),),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (_){
                            return LoginScreen();
                          }));
                        },
                        child: GradientWidget(
                          child: Text("Login.", style: TextStyle(color: Colors.white),
                          ),
                          gradient: AppGradients.neonPinkBlueGradient(),
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 25,),


                  // Text("Do you have a acccount?")
                ],
              ),

            ),
          ),

          BlocConsumer<AuthPageCubit, AuthPageState>(
            builder: (context, state){
              if(state is AuthPageLoading){
                return Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: ModalBarrier(
                        color: Colors.black.withOpacity(0.5),
                        dismissible: false,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.neonPinkColor,
                      ),
                    )
                  ],
                );
              }

              return const SizedBox();
            },
            listener: (context, state){
              if(state is AuthPageLoaded){
                if(state.hasEntered == true) {
                  Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_){
                    return const MyHomePage();
                  }), (route) => false);
                }
              }

              if(state is AuthPageError){
                ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(state.errorMessage)));
              }
            },
          )
        ],
      ),
    );
  }
}
