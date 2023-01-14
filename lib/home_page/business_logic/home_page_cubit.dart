import 'package:bloc/bloc.dart';
import 'package:crowdpad_assignment/common_models/VideoModel.dart';
import 'package:crowdpad_assignment/home_page/data/api/videos_api_handler.dart';
import 'package:meta/meta.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageInitial());

  Future<void> getAllVideos() async{
    try {
      emit(const HomePageLoading());
      List<VideoModel>? isVideoUploaded = await VideosApiHandler.getAllVideos();
      emit(HomePageLoaded(isVideoUploaded));
    }
    catch(e){
      emit(HomePageError("$e"));
    }
  }

  void resetCubit(){
    emit(const HomePageInitial());
  }

}
