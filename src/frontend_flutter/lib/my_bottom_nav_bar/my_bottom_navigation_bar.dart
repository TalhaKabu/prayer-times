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
    return BottomNavigationBar(
      items: bottomNavItems.map((item) {
        return BottomNavigationBarItem(
          label: item.label,
          icon: SvgPicture.asset(
            item.iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).unselectedWidgetColor,
              BlendMode.srcIn,
            ),
          ),
          activeIcon: SvgPicture.asset(
            item.activeIconPath,
            width: 30,
            height: 30,
            colorFilter: ColorFilter.mode(
              Theme.of(context).primaryColor,
              BlendMode.srcIn,
            ),
          ),
          backgroundColor: Colors.grey[200],
        );
      }).toList(),
      // items: <BottomNavigationBarItem>[
      //   BottomNavigationBarItem(
      //     backgroundColor: Colors.grey[200],
      //     label: "Prayer Times",
      //     icon: SvgPicture.asset(
      //       'assets/svgs/pray.svg',
      //       width: 24,
      //       height: 24,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).unselectedWidgetColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //     activeIcon: SvgPicture.asset(
      //       'assets/svgs/pray.svg',
      //       width: 30,
      //       height: 30,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).primaryColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "Quran",
      //     icon: SvgPicture.asset(
      //       'assets/svgs/quran.svg',
      //       width: 24,
      //       height: 24,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).unselectedWidgetColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //     activeIcon: SvgPicture.asset(
      //       'assets/svgs/quran.svg',
      //       width: 30,
      //       height: 30,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).primaryColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "Qible",
      //     icon: SvgPicture.asset(
      //       'assets/svgs/compass.svg',
      //       width: 24,
      //       height: 24,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).unselectedWidgetColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //     activeIcon: SvgPicture.asset(
      //       'assets/svgs/compass.svg',
      //       width: 30,
      //       height: 30,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).primaryColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //   ),
      //   BottomNavigationBarItem(
      //     label: "More",
      //     icon: SvgPicture.asset(
      //       'assets/svgs/more.svg',
      //       width: 24,
      //       height: 24,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).unselectedWidgetColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //     activeIcon: SvgPicture.asset(
      //       'assets/svgs/more.svg',
      //       width: 30,
      //       height: 30,
      //       colorFilter: ColorFilter.mode(
      //         Theme.of(context).primaryColor,
      //         BlendMode.srcIn,
      //       ),
      //     ),
      //   ),
      // ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
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
