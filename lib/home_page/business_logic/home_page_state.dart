part of 'home_page_cubit.dart';

@immutable
abstract class HomePageState {
  const HomePageState();
}

class HomePageInitial extends HomePageState {
  const HomePageInitial();
}

class HomePageLoading extends HomePageState {
  const HomePageLoading();
}

class HomePageLoaded extends HomePageState {
  final List<VideoModel>? listOfVideos;
  const HomePageLoaded(this.listOfVideos);
}

class HomePageError extends HomePageState {
  final String errorMessage;
  const HomePageError(this.errorMessage);
}

