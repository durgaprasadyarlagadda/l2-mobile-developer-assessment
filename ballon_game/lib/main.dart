import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Pop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int timeLeft = 120; // 2 minutes in seconds
  int score = 0;
  int balloonsPopped = 0;
  int balloonsMissed = 0;

  final Random random = Random();
  List<Balloon> balloons = [];

  bool isGameStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balloon Pop Game'),
      ),
      body: Center(
        child: isGameStarted
            ? buildGame()
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGameStarted = true;
                  });
                  startTimer();
                  generateBalloons();
                },
                child: Text('Start'),
              ),
      ),
    );
  }

  Widget buildGame() {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            'Time Left: ${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Score: $score',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Balloons Popped: $balloonsPopped',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Balloons Missed: $balloonsMissed',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        ...balloons,
      ],
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      if (timeLeft == 0) {
        timer.cancel();
        // Game over
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void generateBalloons() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        var x = random.nextInt(300); // Random X position
        var y = 700.0; // Bottom of the screen
        balloons.add(Balloon(x: x.toDouble(), y: y));
      });
    });
  }
}

class Balloon extends StatelessWidget {
  final double x;
  final double y;

  const Balloon({Key? key, required this.x, required this.y}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 2),
      curve: Curves.linear,
      left: x,
      bottom: y,
      child: GestureDetector(
        onTap: () {
          // Handle balloon tap
        },
        child: Image.asset(
          'assets/balloon.png',
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
