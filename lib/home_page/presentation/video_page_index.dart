import 'package:crowdpad_assignment/common_models/VideoModel.dart';
import 'package:crowdpad_assignment/home_page/business_logic/home_page_cubit.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:rive/rive.dart';
import 'package:video_player/video_player.dart';

class VideoPageIndex extends StatefulWidget {
  final List<VideoModel> listOfVideos;
  final int index;
  const VideoPageIndex({Key? key, required this.listOfVideos, required this.index}) : super(key: key);

  @override
  State<VideoPageIndex> createState() => _VideoPageIndexState();
}

class _VideoPageIndexState extends State<VideoPageIndex> with SingleTickerProviderStateMixin{

  // late VideoPlayerController _videoPlayerController;
  late AnimationController _animationController;
  // Animation _animation;
  final _offsetToTrigger = 180.0;




  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(seconds: 2),
    );

  }



  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator
      (child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: widget.index, viewportFraction: 1),
        itemCount: widget.listOfVideos.length, //videoController.videoList.length,
        itemBuilder: (context, index) {
          String videoUrl = widget.listOfVideos[index].videoUrl! ;
          return CustomVideoPlayer(videoUrl: videoUrl);
        }),
      onRefresh: () => BlocProvider.of<HomePageCubit>(context).getAllVideos(),
      offsetToArmed: _offsetToTrigger,
      builder: (context, child,  controller){
        // todo learn more about AnimatedBuilder
        return AnimatedBuilder(
            animation: controller,
            child: child,
            builder: (context,child){
              return Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: _offsetToTrigger * controller.value,
                      child: RiveAnimation.asset('assets/rocket.riv', fit: BoxFit.cover,)
                  ),
                  Transform.translate(
                    offset: Offset(0.0, _offsetToTrigger * controller.value),
                    child: child,
                  )

                ],
              );
            }
        );
      },
    );

  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;


  const CustomVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {

  late VideoPlayerController _videoPlayerController;
  bool _isVideoPlaying = true;



  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)..initialize().then((value){
      setState(() {});
      _videoPlayerController.play();
      _videoPlayerController.setLooping(true);
    });

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(_videoPlayerController.value.isPlaying){
          _videoPlayerController.pause();
          setState(() {
            _isVideoPlaying = false;
          });
        }else{
          _videoPlayerController.play();
          setState(() {
            _isVideoPlaying = true;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: VideoPlayer(_videoPlayerController),
          ),
          Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: Icon(_isVideoPlaying ? Icons.pause : Icons.play_arrow ),
            ),
          )
        ],
      ),

    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }


}

