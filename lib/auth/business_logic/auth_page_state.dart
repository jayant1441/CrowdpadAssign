part of 'auth_page_cubit.dart';

@immutable
abstract class AuthPageState {
  const AuthPageState();
}

class AuthPageInitial extends AuthPageState {
  const AuthPageInitial();
}

class AuthPageLoading extends AuthPageState {
  const AuthPageLoading();
}

class AuthPageLoaded extends AuthPageState {
  final bool? hasEntered;
  const AuthPageLoaded(this.hasEntered);
}

class AuthPageError extends AuthPageState {
  final String errorMessage;
  const AuthPageError(this.errorMessage);
}

