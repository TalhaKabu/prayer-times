import 'dart:math';

import 'package:frontend_flutter/helpers/prayer_times_model.dart';

class PrayerTimesCalculatorHelper {
  static const double deg2Rad = pi / 180;
  static const double rad2Deg = 180 / pi;

  static const double fajrAngle = -18;
  static const double sunriseAngle = -0.833;
  static const double ishaAngle = -17;

  static const double timeZone = 3;

  static List<PrayerTimesModel> calculate(
    double lat,
    double lng,
    DateTime date,
  ) {
    date = DateTime(date.year, date.month, date.day, 12, 0, 0);

    double jd = _julianDay(date);
    double n = jd - 2451545.0;

    double decl = _sunDeclination(n);
    double eqTime = _equationOfTime(n);

    double dhuhr = 12 + timeZone - lng / 15 - eqTime;

    double fajr = dhuhr - _hourAngle(lat, decl, fajrAngle) / 15;
    double sunrise = dhuhr - _hourAngle(lat, decl, sunriseAngle) / 15;

    double asr = dhuhr + _asrAngle(lat, decl) / 15;

    double sunset = dhuhr + _hourAngle(lat, decl, sunriseAngle) / 15;
    double isha = dhuhr + _hourAngle(lat, decl, ishaAngle) / 15;

    return [
      PrayerTimesModel(
        index: 0,
        name: 'Sabah',
        date: _toDate(date, fajr + 0.2 / 60),
        iconPath: 'assets/svgs/fajr.svg',
      ),
      PrayerTimesModel(
        index: 1,
        name: 'Güneş',
        date: _toDate(date, sunrise - 7.0 / 60),
        iconPath: 'assets/svgs/sunrise.svg',
      ),
      PrayerTimesModel(
        index: 2,
        name: 'Öğle',
        date: _toDate(date, dhuhr + 5.0 / 60),
        iconPath: 'assets/svgs/dhuhr.svg',
      ),
      PrayerTimesModel(
        index: 3,
        name: 'İkindi',
        date: _toDate(date, asr + 4.0 / 60),
        iconPath: 'assets/svgs/asr.svg',
      ),
      PrayerTimesModel(
        index: 4,
        name: 'Akşam',
        date: _toDate(date, sunset + 7.0 / 60),
        iconPath: 'assets/svgs/sunset.svg',
      ),
      PrayerTimesModel(
        index: 5,
        name: 'Yatsı',
        date: _toDate(date, isha + 0.1 / 60),
        iconPath: 'assets/svgs/isha.svg',
      ),
    ];
  }

  static double _julianDay(DateTime date) {
    int Y = date.year;
    int M = date.month;
    int D = date.day;

    if (M <= 2) {
      Y -= 1;
      M += 12;
    }

    int A = (Y / 100).floor();
    int B = 2 - A + (A / 4).floor();

    return (365.25 * (Y + 4716)).floor() +
        (30.6001 * (M + 1)).floor() +
        D +
        B -
        1524.5;
  }

  static double _sunDeclination(double day) {
    double g = deg2Rad * (357.529 + 0.98560028 * day);

    double L =
        deg2Rad *
        (280.459 + 0.98564736 * day + 1.915 * sin(g) + 0.020 * sin(2 * g));

    return rad2Deg * asin(sin(23.44 * deg2Rad) * sin(L));
  }

  static double _equationOfTime(double day) {
    double g = deg2Rad * (357.529 + 0.98560028 * day);

    double q = 280.459 + 0.98564736 * day;

    double L = deg2Rad * (q + 1.915 * sin(g) + 0.020 * sin(2 * g));

    double RA = rad2Deg * atan2(cos(23.44 * deg2Rad) * sin(L), cos(L));

    return (q / 15 - RA / 15) + 0.0008 * sin(2 * pi * day / 365);
  }

  static double _hourAngle(double lat, double decl, double angle) {
    double latRad = lat * deg2Rad;
    double declRad = decl * deg2Rad;
    double angleRad = angle * deg2Rad;

    double cosH =
        (sin(angleRad) - sin(latRad) * sin(declRad)) /
        (cos(latRad) * cos(declRad));

    cosH = cosH.clamp(-1, 1);

    return acos(cosH) * rad2Deg;
  }

  static double _asrAngle(double lat, double decl) {
    double latRad = lat * deg2Rad;
    double declRad = decl * deg2Rad;

    double shadow = (tan(latRad - declRad)).abs();

    shadow += 1; // Hanafi

    double angle = atan(1.0 / shadow);

    double H = acos(
      (sin(angle) - sin(latRad) * sin(declRad)) / (cos(latRad) * cos(declRad)),
    );

    return H * rad2Deg;
  }

  static DateTime _toDate(DateTime baseDate, double hour) {
    hour = ((hour % 24) + 24) % 24;

    final midnight = DateTime(baseDate.year, baseDate.month, baseDate.day);

    return midnight.add(Duration(minutes: (hour * 60).round()));
  }
}
