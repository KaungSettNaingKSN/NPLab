import 'package:flutter/material.dart';
import 'package:nplab/screen/category_screen.dart';
import 'package:nplab/screen/home_screen.dart';
import 'package:nplab/screen/results_screen.dart';
import 'package:nplab/provider/test_provider.dart';
import 'package:nplab/screen/test_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TestProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NPLab',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/category': (context) => const CategoryScreen(),
        '/test': (context) => const TestScreen(),
        '/results': (context) => const ResultsScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Unknown Route')),
            body: Center(child: Text('Page not found: ${settings.name}')),
          ),
        );
      },
    );
  }
}
