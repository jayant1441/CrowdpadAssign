import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:crowdpad_assignment/auth/data/api/auth_api_handler.dart';
import 'package:meta/meta.dart';

part 'auth_page_state.dart';

class AuthPageCubit extends Cubit<AuthPageState> {
  AuthPageCubit() : super(const AuthPageInitial());

  Future<void> signUp(String userName, String email, String password, File image ) async{
    try {
      emit(const AuthPageLoading());
      bool? isUserSignedUp = await AuthApiHandler.signUpUser(userName, email, password, image);
      emit(AuthPageLoaded(isUserSignedUp));
    }
    catch(e){
      emit(AuthPageError("$e"));
    }
  }

  Future<void> login(String email, String password) async{
    try {
      emit(const AuthPageLoading());
      bool? isUserLoggedIn = await AuthApiHandler.login( email, password);
      emit(AuthPageLoaded(isUserLoggedIn));
    }
    catch(e){
      emit(AuthPageError("$e"));
    }
  }

  void resetCubit(){
    emit(const AuthPageInitial());
  }

}
