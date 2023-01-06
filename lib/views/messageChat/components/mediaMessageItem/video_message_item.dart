import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoMessageItem extends StatefulWidget {
  const VideoMessageItem({
    super.key,
    required this.urlVideo,
  });
  final String urlVideo;
  @override
  State<VideoMessageItem> createState() => _VideoMessageItemState();
}

class _VideoMessageItemState extends State<VideoMessageItem> {
  late VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerWidget();
  }

  _initVideoPlayer() async {
    videoController = VideoPlayerController.network(widget.urlVideo);
    videoController.addListener(() {
      setState(() {});
    });
    await videoController.setLooping(true);
    videoController.value.volume == 0;
    await videoController.initialize();
  }

  _videoPlayerWidget() {
    return videoController.value.isInitialized
        ? _buildVideoPlayer()
        : const CircularProgressIndicator();
  }

  _buildVideoPlayer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        20.w,
      ),
      child: AspectRatio(
        aspectRatio: videoController.value.aspectRatio,
        child: GestureDetector(
          onTap: () {
            setState(() {
              videoController.value.isPlaying
                  ? videoController.pause()
                  : videoController.play();
            });
          },
          child: Stack(
            children: [
              VideoPlayer(
                videoController,
              ),
              Center(
                child: Icon(
                  videoController.value.isPlaying
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_outlined,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
