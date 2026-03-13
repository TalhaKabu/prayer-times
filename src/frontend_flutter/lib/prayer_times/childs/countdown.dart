import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_flutter/models/prayer_times/prayer_times_model.dart';
import 'package:intl/intl.dart';

class Countdown extends StatefulWidget {
  Countdown({
    required this.prayerTimesItems,
    required this.onDateDayChanged,
    required this.onCountDownZero,
    super.key,
  });

  final CountdownModel countdownModel = CountdownModel();
  final List<PrayerTimesModel> prayerTimesItems;
  final ValueChanged<DateTime> onDateDayChanged;
  final ValueChanged<DateTime> onCountDownZero;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late Timer _timer;
  // DateTime _currentDate = DateTime(2026, 3, 14, 23, 59, 40);
  DateTime _date = DateTime.now();
  // DateTime(
  //   2026,
  //   3,
  //   14,
  //   23,
  //   59,
  //   40,
  // );

  void calculateCountDown() {
    // test amacli
    // if (_currentDate.day != _date.day) {
    //   _date = DateTime(2026, 3, _date.day, 23, 58, 00);
    //   _currentDate = _date;
    //   widget.onDateDayChanged.call(_date);
    //   return;
    // }

    if (DateTime.now().day != _date.day) {
      widget.onDateDayChanged.call(_date);
      return;
    }

    var nextTimeIndex = widget.prayerTimesItems.indexWhere(
      (x) => x.isNext == true,
    );

    var difference = widget.prayerTimesItems[nextTimeIndex].date.difference(
      _date,
    );

    if (difference.isNegative || difference.inSeconds == 0) {
      widget.onCountDownZero.call(_date);
    } else {
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      int seconds = difference.inSeconds % 60;

      setState(() {
        widget.countdownModel.hour = hours.toString().padLeft(2, '0');
        widget.countdownModel.minute = minutes.toString().padLeft(2, '0');
        widget.countdownModel.second = seconds.toString().padLeft(2, '0');
        widget.countdownModel.timeName =
            widget.prayerTimesItems[nextTimeIndex].name;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _date = DateTime.now();
        // _date = _date.add(Duration(seconds: 1)); // test amacli
        calculateCountDown();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 5,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/location.svg',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text('Türkiye / Bursa'),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: colorScheme.secondaryFixed,
                ),
                child: Text(
                  widget.countdownModel.timeName != null
                      ? '${widget.countdownModel.timeName} Vaktine Kalan'
                      : 'Yükleniyor...',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  widget.countdownModel.hour ?? '--',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight(900),
                  ),
                ),
              ),
              Text(':'),
              Container(
                padding: EdgeInsets.all(8),
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  widget.countdownModel.minute ?? '--',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight(900),
                  ),
                ),
              ),
              Text(':'),
              Container(
                padding: EdgeInsets.all(8),
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  widget.countdownModel.second ?? '--',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight(900),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
