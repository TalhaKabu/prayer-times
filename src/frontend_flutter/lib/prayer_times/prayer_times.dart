import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_flutter/helpers/prayer_times_calculator_helper.dart';
import 'package:frontend_flutter/helpers/prayer_times_model.dart';
import 'package:intl/intl.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({super.key});

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  late Timer _timer;
  DateTime _date = DateTime.now();
  late String _countDown = "00:00:00";
  List<PrayerTimesModel> _prayerTimesItems = [];

  Future<void> loadPrayerTimes() async {
    final result = PrayerTimesCalculatorHelper.calculate(
      41.0082, // latitude
      28.9784, // longitude
      DateTime.now(),
    );

    setState(() {
      _prayerTimesItems = result;

      for (int i = 0; i < _prayerTimesItems.length; i++) {
        int nextIndex = (i + 1) % _prayerTimesItems.length;

        if (_prayerTimesItems[i].index == 0) {
          if (_prayerTimesItems[i].date.isAfter(_date)) {
            _prayerTimesItems[5].isSelected = true;
            break;
          }
        }

        if (_prayerTimesItems[i].date.isBefore(_date) &&
            _prayerTimesItems[nextIndex].date.isAfter(_date)) {
          _prayerTimesItems[i].isSelected = true;
          break;
        }
      }
    });
  }

  void calculateCountDown() {
    var selectedTimeIndex = _prayerTimesItems.indexWhere(
      (x) => x.isSelected == true,
    );

    var nextIndex = _prayerTimesItems[selectedTimeIndex].index + 1;
    if (nextIndex > 5) nextIndex = 0;

    var difference = _prayerTimesItems[nextIndex].date.difference(_date);

    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    setState(() {
      _countDown =
          '${_prayerTimesItems[nextIndex].name} in ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  @override
  void initState() {
    super.initState();
    loadPrayerTimes().then(
      (_) => {
        _timer = Timer.periodic(Duration(seconds: 1), (_) {
          setState(() {
            _date = DateTime.now();
          });
          calculateCountDown();
        }),
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel(); // Timer'ı iptal et, memory leak olmasın
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      spacing: 20,
      children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.secondary, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    _countDown,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight(500),
                      fontSize: 45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Column(
            spacing: 10,
            children: _prayerTimesItems.map((item) {
              return Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: item.isSelected
                      ? Border.all(
                          color: colorScheme.primary.withOpacity(0.8),
                          width: 1,
                        )
                      : null,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: item.isSelected
                      ? colorScheme.primaryFixed
                      : Colors.white,
                  boxShadow: item.isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withOpacity(0.8),
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(1, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: item.isSelected
                                    ? colorScheme.primary
                                    : colorScheme.secondaryFixed,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: SvgPicture.asset(
                                item.iconPath,
                                height: 24,
                                width: 24,
                                colorFilter: item.isSelected == true
                                    ? ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      )
                                    : ColorFilter.mode(
                                        colorScheme.secondary,
                                        BlendMode.srcIn,
                                      ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    color: item.isSelected
                                        ? colorScheme.primary
                                        : colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat('HH:mm').format(item.date),
                          style: TextStyle(
                            color: item.isSelected
                                ? colorScheme.primary
                                : colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
