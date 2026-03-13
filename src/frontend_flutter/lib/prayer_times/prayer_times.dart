import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/helpers/prayer_times_calculator_helper.dart';
import 'package:frontend_flutter/models/prayer_times/prayer_times_model.dart';
import 'package:frontend_flutter/prayer_times/childs/countdown.dart';
import 'package:frontend_flutter/prayer_times/childs/times.dart';
import 'package:intl/intl.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({super.key});

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  bool _isLoading = false;
  DateTime _date = DateTime.now();
  // DateTime(
  //   2026,
  //   3,
  //   14,
  //   23,
  //   59,
  //   40,
  // );
  double lat = 41.0082;
  double lng = 28.9784;
  List<PrayerTimesModel> _prayerTimesItems = [];

  void _onDateDayChanged(DateTime date) {
    setState(() {
      _date = date;
    });
    loadPrayerTimes();
  }

  void _onCountdownZero(DateTime date) {
    setState(() {
      _date = date;
    });
    changeSelectedTime();
  }

  Future<void> loadPrayerTimes() async {
    _isLoading = true;

    var dateTomorrow = DateTime(
      _date.year,
      _date.month,
      _date.day + 1,
      12,
      0,
      0,
    );

    _prayerTimesItems = PrayerTimesCalculatorHelper.calculate(lat, lng, _date);

    _prayerTimesItems.addAll(
      PrayerTimesCalculatorHelper.calculate(lat, lng, dateTomorrow),
    );

    _prayerTimesItems.sort((a, b) {
      int dateCompare = a.date.compareTo(b.date);

      if (dateCompare != 0) {
        return dateCompare;
      }

      return a.index.compareTo(b.index);
    });

    // test amacli
    // _prayerTimesItems[0].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[0].date.day,
    //   23,
    //   58,
    //   30,
    // );
    // _prayerTimesItems[1].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[1].date.day,
    //   23,
    //   58,
    //   40,
    // );
    // _prayerTimesItems[2].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[2].date.day,
    //   23,
    //   58,
    //   50,
    // );
    // _prayerTimesItems[3].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[4].date.day,
    //   23,
    //   59,
    //   00,
    // );
    // _prayerTimesItems[4].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[4].date.day,
    //   23,
    //   59,
    //   10,
    // );
    // _prayerTimesItems[5].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[5].date.day,
    //   23,
    //   59,
    //   20,
    // );
    // _prayerTimesItems[6].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[6].date.day,
    //   23,
    //   58,
    //   40,
    // );
    // _prayerTimesItems[7].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[7].date.day,
    //   23,
    //   58,
    //   50,
    // );
    // _prayerTimesItems[8].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[8].date.day,
    //   23,
    //   59,
    //   00,
    // );
    // _prayerTimesItems[9].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[9].date.day,
    //   23,
    //   59,
    //   10,
    // );
    // _prayerTimesItems[10].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[10].date.day,
    //   23,
    //   59,
    //   20,
    // );
    // _prayerTimesItems[11].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[11].date.day,
    //   23,
    //   59,
    //   30,
    // );

    changeSelectedTime();
  }

  void changeSelectedTime() {
    int currentTimeIndex = _prayerTimesItems.indexWhere((x) => x.isSelected);
    int nextTimeIndex = _prayerTimesItems.indexWhere((x) => x.isNext);

    if (!currentTimeIndex.isNegative) {
      _prayerTimesItems[currentTimeIndex].isSelected = false;
    }

    if (!nextTimeIndex.isNegative) {
      _prayerTimesItems[nextTimeIndex].isNext = false;
    }

    for (int i = 0; i < _prayerTimesItems.length; i++) {
      int nextIndex = (i + 1) % _prayerTimesItems.length;

      if (_prayerTimesItems[i].date == _date) {
        currentTimeIndex = i;
        nextTimeIndex = nextIndex;
        break;
      }

      if (_prayerTimesItems[i].index == 0) {
        if (_prayerTimesItems[i].date.isAfter(_date)) {
          currentTimeIndex = 5;
          nextTimeIndex = 0;
          break;
        }
      }

      if (_prayerTimesItems[i].date.isBefore(_date) &&
          _prayerTimesItems[nextIndex].date.isAfter(_date)) {
        currentTimeIndex = i;
        nextTimeIndex = nextIndex;
        break;
      }
    }

    setState(() {
      _prayerTimesItems[currentTimeIndex].isSelected = true;
      _prayerTimesItems[nextTimeIndex].isNext = true;
    });

    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    loadPrayerTimes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: _isLoading
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: !_isLoading
          ? [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(DateFormat("dd MM yyyy HH:mm:ss").format(_date)),
                  Text('-'),
                  Text('20 Ramazan 1447'),
                ],
              ),
              SizedBox(height: 10),
              Countdown(
                prayerTimesItems: _prayerTimesItems,
                onDateDayChanged: _onDateDayChanged,
                onCountDownZero: _onCountdownZero,
              ),
              SizedBox(height: 10),
              Times(
                prayerTimesItems: _prayerTimesItems
                    .where((x) => x.date.day == _date.day)
                    .toList(),
              ),
            ]
          : [
              Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                  strokeWidth: 3,
                ),
              ),
            ],
    );
  }
}
