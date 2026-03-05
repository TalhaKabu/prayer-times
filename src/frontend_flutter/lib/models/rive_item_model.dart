import 'package:frontend_flutter/models/rive_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({required this.title, required this.rive});
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    title: 'Namaz Vakitleri',
    rive: RiveModel(
      src: "assets/animated-icons.riv",
      artboard: "HOME",
      stateMachineName: 'HOME_interactivity',
    ),
  ),
  NavItemModel(
    title: 'Kuran',
    rive: RiveModel(
      src: "assets/animated-icons.riv",
      artboard: "SEARCH",
      stateMachineName: 'SEARCH_Interactivity',
    ),
  ),
];
