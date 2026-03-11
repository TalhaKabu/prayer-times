class PrayerTimesModel {
  final int index;
  final String name;
  final String iconPath;
  DateTime date;
  bool isSelected = false;
  bool isNext = false;

  PrayerTimesModel({
    required this.index,
    required this.name,
    required this.iconPath,
    required this.date,
  });
}

class CountdownModel {
  String? hour;
  String? minute;
  String? second;
  String? timeName;

  CountdownModel({this.hour, this.minute, this.second, this.timeName});
}
