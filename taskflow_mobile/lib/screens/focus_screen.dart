import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int workMinutes = 25;
  int secondsRemaining = workMinutes * 60;
  bool isRunning = false;
  Timer? timer;

  void toggleTimer() {
    if (isRunning) {
      timer?.cancel();
    } else {
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (secondsRemaining > 0) {
          setState(() => secondsRemaining--);
        } else {
          t.cancel();
          setState(() => isRunning = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🎉 Focus session complete! Take a break.')),
            );
          }
        }
      });
    }
    setState(() => isRunning = !isRunning);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      secondsRemaining = workMinutes * 60;
      isRunning = false;
    });
  }

  String get timerText {
    int m = secondsRemaining ~/ 60;
    int s = secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percent = 1 - (secondsRemaining / (workMinutes * 60));

    return Scaffold(
      appBar: AppBar(title: const Text("🍅 Focus Mode")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 15.0,
              percent: percent,
              center: Text(
                timerText,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.redAccent,
              backgroundColor: Colors.grey.shade300,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  onPressed: toggleTimer,
                  child: Icon(isRunning ? Icons.pause : Icons.play_arrow, size: 36),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: resetTimer,
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              isRunning ? "Stay focused!" : "Ready to focus for 25 minutes?",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
