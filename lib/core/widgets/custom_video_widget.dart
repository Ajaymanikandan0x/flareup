import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../features/events/presentation/cubit/video_player_cubit.dart';

class CustomVideoWidget extends StatefulWidget {
  final String videoUrl;
  final double? width;
  final double? height;
  final Widget placeholder;
  final bool autoPlay;
  final bool looping;
  final VideoPlayerCubit? videoPlayerCubit;

  const CustomVideoWidget({
    super.key,
    required this.videoUrl,
    this.width,
    this.height,
    required this.placeholder,
    this.autoPlay = true,
    this.looping = true,
    this.videoPlayerCubit,
  });

  @override
  State<CustomVideoWidget> createState() => _CustomVideoWidgetState();
}

class _CustomVideoWidgetState extends State<CustomVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    String videoUrl = widget.videoUrl;

    // Handle Cloudinary URLs
    if (videoUrl.contains('image/upload')) {
      videoUrl = videoUrl.replaceAll('image/upload', 'video/upload');
    }

    // Add file extension if not present
    if (!videoUrl.contains('.')) {
      videoUrl = '$videoUrl.mp4';
    } else {
      final validExtensions = [
        '.mp4',
        '.mov',
        '.avi',
        '.mkv',
        '.webm',
        '.m3u8'
      ];
      bool hasValidExtension =
          validExtensions.any((ext) => videoUrl.toLowerCase().endsWith(ext));
      if (!hasValidExtension) {
        videoUrl = '$videoUrl.mp4';
      }
    }

    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        widget.videoPlayerCubit?.setController(_controller);

        if (widget.autoPlay) {
          await _controller.play();
        }
        if (widget.looping) {
          await _controller.setLooping(true);
        }
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() {
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : widget.placeholder,
    );
  }
}
