import 'package:bloc/bloc.dart';
import 'package:crowdpad_assignment/common_models/VideoModel.dart';
import 'package:crowdpad_assignment/home_page/data/api/videos_api_handler.dart';
import 'package:meta/meta.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(const HomePageLoading());

  List<VideoModel>? allVideos;

  Future<void> getAllVideos({bool fetchNewVideos = false}) async{
    try {
      emit(const HomePageLoading());
      if (allVideos != null && allVideos!.isNotEmpty && !fetchNewVideos){
        emit(HomePageLoaded(allVideos));
      }
      else{
        allVideos = await VideosApiHandler.getAllVideos();
        emit(HomePageLoaded(allVideos));
      }

    }
    catch(e){
      emit(HomePageError("$e"));
    }
  }

  void resetCubit(){
    emit(const HomePageInitial());
  }

}
