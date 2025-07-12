import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../core/widgets/loading.dart';


class AboutUsVideo extends StatefulWidget {
  final String videoUrl;

  const AboutUsVideo({super.key, required this.videoUrl});

  @override
  _AboutUsVideoState createState() => _AboutUsVideoState();
}

class _AboutUsVideoState extends State<AboutUsVideo> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  void _restartVideo() {
    _controller?.seekTo(Duration.zero);
    if (!_controller!.value.isPlaying) {
      _controller?.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _goToFullScreen() {
    if (_controller != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(controller: _controller!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller != null && _controller!.value.isInitialized
        ? ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _restartVideo,
                  icon: const Icon(
                    Icons.replay,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _goToFullScreen,
                  icon: const Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        : Container(
      height: 111,
      width: 343,
      color: Colors.black,
      child: const Center(child: CustomDotsTriangleLoader()),
    );
  }
}
class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({super.key, required this.controller});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    _isPlaying = _controller.value.isPlaying;

    if (!_isPlaying) {
      _controller.play();
      _isPlaying = true;
    }

    _controller.setLooping(true);
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _restartVideo() {
    _controller.seekTo(Duration.zero);
    if (!_controller.value.isPlaying) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _togglePlayPause,
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: _restartVideo,
                    icon: const Icon(
                      Icons.replay,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.fullscreen_exit,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
