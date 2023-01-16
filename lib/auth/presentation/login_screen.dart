import 'package:crowdpad_assignment/auth/business_logic/auth_page_cubit.dart';
import 'package:crowdpad_assignment/auth/presentation/signup_screen.dart';
import 'package:crowdpad_assignment/home_page/presentation/home_page_index.dart';
import 'package:crowdpad_assignment/utils/app_utils.dart';
import 'package:crowdpad_assignment/utils/colors_constant.dart';
import 'package:crowdpad_assignment/widgets/gredient_widget.dart';
import 'package:crowdpad_assignment/widgets/outlined_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/text_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController =  TextEditingController();
  final TextEditingController _passwordController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            //const - Constant - Value - String , Int  - Fix Rahega  - Use Karna
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                GradientWidget(
                    child: const Text("CROWDPAD", style: TextStyle(fontWeight: FontWeight.w900 ,fontSize: 25, letterSpacing: 5),),
                    gradient: AppGradients.neonPinkBlueGradient()
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    controller: _emailController,
                    myLabelText: "Email",
                    myIcon: Icons.email,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    controller: _passwordController,
                    myLabelText: "Password",
                    myIcon: Icons.lock,
                    toHide: true,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyOutlinedButton(
                    gradient: AppGradients.neonPinkBlueGradient(),
                    onPressed: (){

                      String email = _emailController.text;
                      String password = _emailController.text;
                      if(email.isEmpty || password.isEmpty || !AppUtils.isEmailCorrect(email)){
                        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Please fill all the details correctly!")));
                        return;
                      }

                      BlocProvider.of<AuthPageCubit>(context).login(email, password);
                    },
                    child:  Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50 , vertical: 10),

                        child: GradientWidget(
                            gradient: AppGradients.neonPinkBlueGradient(),

                            child: const Text("Login",))
                    )
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do not have an account ?  ", style: TextStyle(color: Colors.white),),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_){
                          return SignUpScreen();
                        }), (route) => false);
                      },
                      child: GradientWidget(
                        child: const Text("Sign Up.", style: TextStyle(color: Colors.white),
                        ),
                        gradient: AppGradients.neonPinkBlueGradient(),
                      ),
                    )

                  ],
                ),
              ],
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
