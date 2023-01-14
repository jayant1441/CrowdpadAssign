import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crowdpad_assignment/upload_video_page/data/upload_video_api_handler.dart';
import 'package:meta/meta.dart';
part 'upload_video_state.dart';

class UploadVideoCubit extends Cubit<UploadVideoState> {
  UploadVideoCubit() : super(const UploadVideoInitial());

  Future<void> uploadVideos(String videoPath) async{
    try {
      emit(const UploadVideoLoading());
      bool? isVideoUploaded = await UploadVideoApiHandler.uploadVideo(videoPath);
      emit(UploadVideoLoaded(isVideoUploaded));
    }
    catch(e, stack){
      print("Error $e");
      // print("Error $stack");
      emit(UploadVideoError("$e"));
    }
  }

  void resetCubit(){
    emit(const UploadVideoInitial());
  }
}
