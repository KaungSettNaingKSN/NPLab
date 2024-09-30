import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nplab/provider/test_provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  CategoryScreenState createState() => CategoryScreenState();
}

class CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> levels = ['Grammar', 'Listening', 'Reading'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: levels.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final testProvider = Provider.of<TestProvider>(context, listen: false);
      testProvider.setSelectedCategory('grammar');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testProvider = Provider.of<TestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text(
          'NPLab',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: DefaultTabController(
        length: levels.length,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 0,
                child: Container(
                  height: 35,
                  color: Colors.white,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    controller: _tabController,
                    unselectedLabelColor: Colors.red,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.redAccent,
                    ),
                    onTap: (index) {
                      String selectedCategory = levels[index].toLowerCase();
                      if (testProvider.selectedCategory != selectedCategory) {
                        testProvider.setSelectedCategory(selectedCategory);
                      }
                    },
                    tabs: levels
                        .map((level) => Tab(
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.redAccent, width: 1)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(level),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    levels.map((level) => _buildTabContent(level)).toList(),
              ),
            ),
          ],
        ),
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/test',
              (route) => false,
            );
          },
          child: const Text(
            'Start',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(String level) {
    return Consumer<TestProvider>(
      builder: (context, testProvider, child) {
        final questionCount = testProvider.questions.length;

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  level,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Question',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Score',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '2 min',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '$questionCount ques',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '$questionCount marks',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
