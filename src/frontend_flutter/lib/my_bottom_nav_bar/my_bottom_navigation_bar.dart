import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_flutter/my_bottom_nav_bar/bottom_nav_bar_item_model.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key, required this.onSend});

  final void Function(int) onSend;

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      items: bottomNavItems.map((item) {
        return BottomNavigationBarItem(
          label: item.label,
          icon: SvgPicture.asset(
            item.iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              colorScheme.secondary,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            item.activeIconPath,
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
          ),
          backgroundColor: Colors.white,
        );
      }).toList(),
      currentIndex: _selectedIndex,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(size: 24), // aktif ikon boyutu
      unselectedIconTheme: IconThemeData(size: 24),
      selectedLabelStyle: TextStyle(fontSize: 14), // aktif label
      unselectedLabelStyle: TextStyle(fontSize: 12), // pasif label
      showUnselectedLabels: true,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        widget.onSend(index);
      },
      backgroundColor: Colors.grey[200],
    );
  }
}
