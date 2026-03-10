class PrayerTimesModel {
  final int index;
  final String name;
  bool isSelected = false;
  final String iconPath;
  DateTime date;

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
