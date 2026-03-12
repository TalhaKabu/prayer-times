import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void initState() {
    super.initState();

    // Sistem navigation bar rengini değiştir
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white, // alt bar arka plan rengi
        systemNavigationBarIconBrightness:
            Brightness.dark, // ikonlar siyah olsun
      ),
    );
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
      extendBody: true,
      backgroundColor: colorScheme.onPrimaryFixedVariant,
      appBar: _selectedIndex == 1
          ? null
          : AppBar(
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
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(onSend: getSelectedIndex),
    );
  }
}
