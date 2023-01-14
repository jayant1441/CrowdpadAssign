part of 'upload_video_cubit.dart';

@immutable
abstract class UploadVideoState {
  const UploadVideoState();
}

class UploadVideoInitial extends UploadVideoState {
  const UploadVideoInitial();
}

class UploadVideoLoading extends UploadVideoState {
  const UploadVideoLoading();
}

class UploadVideoLoaded extends UploadVideoState {
  final bool? isUploaded;
  const UploadVideoLoaded(this.isUploaded);
}

class UploadVideoError extends UploadVideoState {
  final String errorMessage;
  const UploadVideoError(this.errorMessage);
}
