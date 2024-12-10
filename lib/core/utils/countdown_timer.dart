
import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/text_theme.dart';

class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final Function() onTimerComplete;

  const CountdownTimer({
    super.key,
    required this.duration,
    required this.onTimerComplete,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onTimerComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      "This code will expire in $minutes:$seconds",
      style: AppTextStyles.hindTextTheme(fontSize: 16),
    );
  }
}
