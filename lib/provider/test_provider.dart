import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nplab/test_data.dart';
import 'package:nplab/model/test_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestProvider with ChangeNotifier {
  String _selectedYear = '2024';
  String _selectedLevel = 'N3';
  String _selectedCategory = 'grammar';
  final List<Test> _tests = getTestData();

  String get selectedCategory => _selectedCategory;
  String get selectedLevel => _selectedLevel;
  String get selectedYear => _selectedYear;

  final Map<String, Map<String, Map<int, int?>>> _selectedAnswers = {};
  int _timerValue = 110;
  Timer? _timer;
  bool _isTimerRunning = false;

  List<Test> get tests => _tests;

  List<Question> get questions => getQuestionsByYearAndLevelTest(
      _selectedYear, _selectedLevel, _selectedCategory);

  List<Question> getQuestionsByYearAndLevelTest(
      String year, String level, String category) {
    final test = _tests.firstWhere(
      (test) => test.year == year && test.level == level,
      orElse: () =>
          throw Exception('Test not found for year $year and level $level'),
    );

    final questionsForCategory = test.questions[category];

    if (questionsForCategory == null) {
      throw Exception(
          'No questions found for $category in year $year and level $level');
    }

    return questionsForCategory;
  }

  Map<int, int?> get selectedAnswers =>
      _selectedAnswers[_selectedYear]?[_selectedCategory] ?? {};

  int get timerValue => _timerValue;
  bool get isTimerRunning => _isTimerRunning;

  Future<void> loadSavedAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final yearCategoryAnswers = _selectedAnswers
        .putIfAbsent(_selectedYear, () => {})
        .putIfAbsent(_selectedCategory, () => {});

    final questions = getQuestionsByYearAndLevelTest(
        _selectedYear, _selectedLevel, _selectedCategory);

    for (int i = 0; i < questions.length; i++) {
      yearCategoryAnswers[i] = prefs.getInt(
          'answer_${_selectedYear}_${_selectedLevel}_${_selectedCategory}_$i');
    }
    notifyListeners();
  }

  Future<void> saveAnswer(int questionIndex, int answerIndex) async {
    final yearCategoryAnswers = _selectedAnswers
        .putIfAbsent(_selectedYear, () => {})
        .putIfAbsent(_selectedCategory, () => {});

    yearCategoryAnswers[questionIndex] = answerIndex;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        'answer_${_selectedYear}_${_selectedLevel}_${_selectedCategory}_$questionIndex',
        answerIndex);

    notifyListeners();
  }

  void startTimer(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue > 0) {
        _timerValue--;
        notifyListeners();
      } else {
        _timer?.cancel();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/results');
        }
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue > 0) {
        _timerValue--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  void setSelectedYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setSelectedLevel(String level) {
    _selectedLevel = level;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int calculateScore() {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (isAnswerCorrect(i)) {
        score++;
      }
    }
    return score;
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    saveAnswer(questionIndex, answerIndex);
    notifyListeners();
  }

  void resetQuiz() async {
    _selectedAnswers[_selectedYear]?[_selectedCategory]?.clear();
    _timerValue = 110;
    _isTimerRunning = false;

    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    for (String key in allKeys) {
      if (key.startsWith(
          'answer_${_selectedYear}_${_selectedLevel}_${_selectedCategory}_')) {
        prefs.remove(key);
      }
    }

    notifyListeners();
  }

  bool isAnswerCorrect(int questionIndex) {
    final answersForCategory =
        _selectedAnswers[_selectedYear]?[_selectedCategory];
    if (answersForCategory == null) {
      return false;
    }

    final test = _tests.firstWhere(
      (test) => test.year == _selectedYear,
      orElse: () => throw Exception('Test not found for year: $_selectedYear'),
    );

    final questionList = test.questions[_selectedCategory];
    if (questionList == null || questionIndex >= questionList.length) {
      return false;
    }

    final question = questionList[questionIndex];
    if (question.correctAnswerIndex == null) {
      return false;
    }

    return answersForCategory[questionIndex] == question.correctAnswerIndex;
  }

  bool hasSavedAnswers() {
    final categoryAnswers = _selectedAnswers[_selectedYear]?[_selectedCategory];
    if (categoryAnswers == null) {
      return false;
    }

    return categoryAnswers.values.any((answer) => answer != null);
  }
}
