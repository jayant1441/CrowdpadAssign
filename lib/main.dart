import 'package:crowdpad_assignment/auth/business_logic/auth_page_cubit.dart';
import 'package:crowdpad_assignment/auth/presentation/login_screen.dart';
import 'package:crowdpad_assignment/auth/presentation/signup_screen.dart';
import 'package:crowdpad_assignment/home_page/business_logic/home_page_cubit.dart';
import 'package:crowdpad_assignment/home_page/presentation/home_page_index.dart';
import 'package:crowdpad_assignment/upload_video_page/business_logic/upload_video_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (BuildContext context) => UploadVideoCubit()),
      BlocProvider(create: (BuildContext context) => HomePageCubit()),
      BlocProvider(create: (BuildContext context) => AuthPageCubit()),
    ],
    child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuth.instance.currentUser == null ? SignUpScreen() : const MyHomePage(),
    );
  }
}

