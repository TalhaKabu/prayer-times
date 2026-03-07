class NavItemModel {
  final String label;
  final String iconPath;
  final String activeIconPath;

  NavItemModel({
    required this.label,
    required this.iconPath,
    required this.activeIconPath,
  });
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    label: "Prayer Times",
    iconPath: "assets/svgs/pray.svg",
    activeIconPath: "assets/svgs/pray.svg",
  ),
  NavItemModel(
    label: "Quran",
    iconPath: "assets/svgs/quran.svg",
    activeIconPath: "assets/svgs/quran.svg",
  ),
  NavItemModel(
    label: "Qible",
    iconPath: "assets/svgs/compass.svg",
    activeIconPath: "assets/svgs/compass.svg",
  ),
  NavItemModel(
    label: "More",
    iconPath: "assets/svgs/more.svg",
    activeIconPath: "assets/svgs/more.svg",
  ),
];
