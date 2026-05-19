import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class SalonVideoWidget extends StatefulWidget {
  final String videoUrl;
  const SalonVideoWidget({super.key, required this.videoUrl});

  @override
  State<SalonVideoWidget> createState() => _SalonVideoWidgetState();
}

class _SalonVideoWidgetState extends State<SalonVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openFullScreen() {
    if (!_isInitialized) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FullScreenVideoPage(
        controller: _controller,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      children: [
        // Title with Underline
        Column(
          children: [
            Text(
              isArabic ? 'شاهد الصالون' : 'Watch the Salon',
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Container(
              height: 2,
              width: 80,
              color: isDark ? Colors.white : Colors.black,
              margin: const EdgeInsets.only(top: 2),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Video Thumbnail
        GestureDetector(
          onTap: _openFullScreen,
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  if (_isInitialized)
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                  // Dark overlay
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                  // Play button icon
                  const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPage({super.key, required this.controller});

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  @override
  void initState() {
    super.initState();
    // Play the video in full screen
    widget.controller.play();
  }

  @override
  void dispose() {
    // Pause when leaving full screen
    widget.controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (widget.controller.value.isPlaying) {
                      widget.controller.pause();
                    } else {
                      widget.controller.play();
                    }
                  });
                },
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  child: VideoPlayer(widget.controller),
                ),
              ),
            ),
            // Custom controls
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                colors: const VideoProgressColors(
                  playedColor: Colors.amber,
                  bufferedColor: Colors.white54,
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Play/Pause icon in center when paused
            if (!widget.controller.value.isPlaying)
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.controller.play();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
