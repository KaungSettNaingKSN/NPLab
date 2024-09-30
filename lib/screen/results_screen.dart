// screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:nplab/screen/home_screen.dart';
import 'package:nplab/provider/test_provider.dart';
import 'package:nplab/screen/test_screen.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<TestProvider>(context, listen: false);
    final score = quizProvider.calculateScore();

    return Scaffold(
      appBar: AppBar(title: const Text('NPLab')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Score: $score/${quizProvider.questions.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: quizProvider.questions.length,
              itemBuilder: (context, index) {
                final question = quizProvider.questions[index];
                final selectedAnswerIndex = quizProvider.selectedAnswers[index];
                final isCorrectAnswer =
                    question.correctAnswerIndex == selectedAnswerIndex;

                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: selectedAnswerIndex == null
                          ? Colors.red
                          : isCorrectAnswer
                              ? Colors.green
                              : Colors.red,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                        final isSelected = selectedAnswerIndex == answerIndex;

                        return ListTile(
                          title: Text(
                            question.answers[answerIndex],
                            style: TextStyle(
                              color: question.correctAnswerIndex == answerIndex
                                  ? Colors.green
                                  : isSelected
                                      ? Colors.red
                                      : null,
                            ),
                          ),
                          leading: Icon(
                            question.correctAnswerIndex == answerIndex
                                ? Icons.check
                                : isSelected
                                    ? Icons.close
                                    : Icons.radio_button_unchecked,
                            color: question.correctAnswerIndex == answerIndex
                                ? Colors.green
                                : isSelected
                                    ? Colors.red
                                    : null,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 10, bottom: 35, right: 10, top: 10),
            width: MediaQuery.of(context).size.width / 2.3,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text(
                'Home',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: 10, bottom: 35, right: 10, top: 10),
            width: MediaQuery.of(context).size.width / 2.3,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                quizProvider.resetQuiz();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TestScreen()),
                );
              },
              child: const Text(
                'Retry',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
