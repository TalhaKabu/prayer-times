import 'package:flutter/material.dart';
import 'package:frontend_flutter/more/more.dart';
import 'package:frontend_flutter/my_bottom_nav_bar/my_bottom_navigation_bar.dart';
import 'package:frontend_flutter/prayer_times/prayer_times.dart';
import 'package:frontend_flutter/qible/qible.dart';
import 'package:frontend_flutter/quran/quran.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void getSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const PrayerTimes(),
      const Quran(),
      const Qible(),
      const More(),
    ];

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.onPrimaryFixedVariant,
      appBar: AppBar(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        leadingWidth: 60,
        titleSpacing: 6,
        title: Text(
          'Namaz Vakitleri',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.grey[600],
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset('assets/logo.png'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(onSend: getSelectedIndex),
    );
  }
}
