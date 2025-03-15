import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerState {
  final bool isPlaying;

  final bool isInitialized;

  VideoPlayerState({
    this.isPlaying = true,
    this.isInitialized = false,
  });

  VideoPlayerState copyWith({
    bool? isPlaying,
    bool? isInitialized,
  }) {
    return VideoPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerController? _controller;

  VideoPlayerCubit() : super(VideoPlayerState());

  void setController(VideoPlayerController controller) {
    _controller = controller;
    // Initialize with current playing state
    emit(state.copyWith(isPlaying: controller.value.isPlaying));
  }

  void setInitialized(bool initialized) {
    emit(state.copyWith(isInitialized: initialized));
  }

  void togglePlayPause() {
    if (_controller == null) {
      debugPrint("Video controller is null");
      return;
    }

    try {
      if (_controller!.value.isPlaying) {
        _controller!.pause().then((_) {
          emit(state.copyWith(isPlaying: false));
        });
      } else {
        _controller!.play().then((_) {
          emit(state.copyWith(isPlaying: true));
        });
      }
    } catch (e) {
      debugPrint("Error toggling play/pause: $e");
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
