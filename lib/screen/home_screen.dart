import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nplab/provider/test_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final levels = ['N5', 'N4', 'N3', 'N2', 'N1'];

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
                        physics: const ClampingScrollPhysics(),
                        controller: _tabController,
                        unselectedLabelColor: Colors.red,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.redAccent,
                        ),
                        tabs: levels
                            .map((level) => Tab(
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
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
                )
              ],
            )));
  }

  Widget _buildTabContent(String level) {
    final testProvider = Provider.of<TestProvider>(context);

    final uniqueYears = testProvider.tests
        .where((test) => test.level == level)
        .map((test) => test.year)
        .toSet()
        .toList();

    if (uniqueYears.isEmpty) {
      return Center(child: Text('No tests found for level $level.'));
    }

    return ListView.builder(
      itemCount: uniqueYears.length,
      itemBuilder: (context, index) {
        final testYear = uniqueYears[index];
        return InkWell(
          onTap: () {
            testProvider.setSelectedYear(testYear);
            testProvider.setSelectedLevel(level);
            Navigator.pushNamed(
              context,
              '/category',
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testYear,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            level,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/clock.gif',
                            height: 50,
                            width: 50,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              '6 min',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
