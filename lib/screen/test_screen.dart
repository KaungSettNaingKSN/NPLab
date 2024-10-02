import 'package:flutter/material.dart';
import 'package:nplab/screen/home_screen.dart';
import 'package:nplab/provider/test_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<TestProvider>(context, listen: false);

    quizProvider.loadSavedAnswers().then((_) {
      if (quizProvider.hasSavedAnswers()) {
        Navigator.pushReplacementNamed(context, '/results');
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          quizProvider.startTimer(context);
          if (quizProvider.selectedCategory == 'listening') {
            _audioPlayer = AudioPlayer();
            _playAudio(
              'audio/${quizProvider.selectedYear}${quizProvider.selectedLevel}.mp3',
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String assetPath) async {
    if (_audioPlayer != null) {
      await _audioPlayer!.play(AssetSource(assetPath));
    }
  }

  Future<void> _pauseAudio() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.pause();
    }
  }

  Future<void> _restartAudio(String assetPath) async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      await _playAudio(assetPath);
    }
  }

  void _togglePlayPause(TestProvider quizProvider) {
    if (_isPlaying) {
      if (quizProvider.selectedCategory == 'listening') {
        _pauseAudio();
      }
      quizProvider.pauseTimer();
    } else {
      if (quizProvider.selectedCategory == 'listening') {
        _playAudio(
          'audio/${quizProvider.selectedYear}${quizProvider.selectedLevel}.mp3',
        );
      }
      quizProvider.resumeTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<TestProvider>(context);

    String formatTime(int totalSeconds) {
      final minutes = totalSeconds ~/ 60;
      final seconds = totalSeconds % 60;
      final minutesStr = minutes.toString().padLeft(2, '0');
      final secondsStr = seconds.toString().padLeft(2, '0');
      return '$minutesStr:$secondsStr';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatTime(quizProvider.timerValue),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'NPLab',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
                _togglePlayPause(quizProvider);
                _showPauseDialog(context, quizProvider);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: quizProvider.questions.length,
        itemBuilder: (context, index) {
          final question = quizProvider.questions[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildQuestionText(question.questionText),
                ),
                question.image == null
                    ? Container()
                    : Image.asset(
                        'assets/image/${question.image}',
                        width: double.maxFinite,
                      ),
                ...List.generate(question.answers.length, (answerIndex) {
                  return RadioListTile<int>(
                    title: Text(question.answers[answerIndex]),
                    value: answerIndex,
                    groupValue: quizProvider.selectedAnswers[index],
                    onChanged: (value) {
                      quizProvider.selectAnswer(index, value!);
                    },
                  );
                }),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () {
            for (int i = 0; i < quizProvider.questions.length; i++) {
              final selectedAnswer = quizProvider.selectedAnswers[i];
              if (selectedAnswer != null) {
                quizProvider.saveAnswer(i, selectedAnswer);
              }
            }
            quizProvider.stopTimer();
            Navigator.pushReplacementNamed(context, '/results');
          },
          child: const Text(
            'Submit',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showPauseDialog(BuildContext context, TestProvider quizProvider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 45),
                        const Text(
                          'NPLab',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          'Sharpen your Japanese skills with every lesson!',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.9 / 3.6,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  quizProvider.resetQuiz();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  'Home',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.9 / 3.6,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  quizProvider.resetQuiz();
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _isPlaying = !_isPlaying;
                                  });
                                  _togglePlayPause(quizProvider);
                                  if (quizProvider.selectedCategory ==
                                      'listening') {
                                    _restartAudio(
                                        'audio/${quizProvider.selectedYear}${quizProvider.selectedLevel}.mp3');
                                  }
                                },
                                child: const Text(
                                  'Restart',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.9 / 3.6,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _isPlaying = !_isPlaying;
                                  });
                                  _togglePlayPause(quizProvider);
                                },
                                child: const Text(
                                  'Resume',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -40,
                left: MediaQuery.of(context).size.width * 0.9 / 2.6,
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget buildQuestionText(String questionText,
    {Color underlineColor = Colors.red}) {
  final parts = questionText.split(RegExp(r'(<u>|</u>)'));

  return RichText(
    text: TextSpan(
      children: parts.map((part) {
        if (part == '<u>' || part == '</u>') {
          return const TextSpan(text: '');
        } else {
          return TextSpan(
            text: part,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: parts.indexOf(part) % 2 == 1 ? Colors.red : Colors.black,
              decoration: parts.indexOf(part) % 2 == 1
                  ? TextDecoration.underline
                  : null,
              decorationColor: parts.indexOf(part) % 2 == 1
                  ? underlineColor
                  : Colors.transparent,
            ),
          );
        }
      }).toList(),
    ),
  );
}
