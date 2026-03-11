import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_flutter/helpers/prayer_times_calculator_helper.dart';
import 'package:frontend_flutter/models/prayer_times/prayer_times_model.dart';
import 'package:intl/intl.dart';
import 'package:memory_cache/memory_cache.dart';

class PrayerTimes extends StatefulWidget {
  const PrayerTimes({super.key});

  @override
  State<PrayerTimes> createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  late Timer _timer;
  bool _isLoading = false;
  DateTime _currentDate = DateTime.now();
  // DateTime(
  //   2026,
  //   3,
  //   10,
  //   23,
  //   59,
  //   30,
  // );
  DateTime _date = DateTime.now();
  // DateTime(
  //   2026,
  //   3,
  //   10,
  //   23,
  //   59,
  //   30,
  // );
  double lat = 41.0082;
  double lng = 28.9784;
  final CountdownModel _countDownModel = CountdownModel();
  List<PrayerTimesModel> _prayerTimesItems = [];

  Future<void> loadPrayerTimes() async {
    _isLoading = true;

    final key = '${DateFormat('dd.MM.yyyy').format(_date)}-$lat-$lng';

    final cacheResult = MemoryCache.instance.read<List<PrayerTimesModel>>(key);

    if (cacheResult != null) {
      _prayerTimesItems = cacheResult;
      return;
    }

    final result = PrayerTimesCalculatorHelper.calculate(lat, lng, _date);
    result.addAll(
      PrayerTimesCalculatorHelper.calculate(
        lat,
        lng,
        DateTime(_date.year, _date.month, _date.day + 1, 12, 0, 0),
      ),
    );

    _prayerTimesItems = result;

    _prayerTimesItems.sort((a, b) {
      int dateCompare = a.date.compareTo(b.date);

      if (dateCompare != 0) {
        return dateCompare;
      }

      return a.index.compareTo(b.index);
    });

    //test amacli
    // _prayerTimesItems[0].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[0].date.day,
    //   23,
    //   58,
    //   50,
    // );
    // _prayerTimesItems[1].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[1].date.day,
    //   23,
    //   59,
    //   00,
    // );
    // _prayerTimesItems[2].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[2].date.day,
    //   23,
    //   59,
    //   10,
    // );
    // _prayerTimesItems[3].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[4].date.day,
    //   23,
    //   59,
    //   20,
    // );
    // _prayerTimesItems[4].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[4].date.day,
    //   23,
    //   59,
    //   30,
    // );
    // _prayerTimesItems[5].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[5].date.day,
    //   23,
    //   59,
    //   40,
    // );
    // _prayerTimesItems[6].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[6].date.day,
    //   0,
    //   0,
    //   10,
    // );
    // _prayerTimesItems[7].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[7].date.day,
    //   0,
    //   0,
    //   20,
    // );
    // _prayerTimesItems[8].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[8].date.day,
    //   0,
    //   0,
    //   30,
    // );
    // _prayerTimesItems[9].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[9].date.day,
    //   0,
    //   0,
    //   40,
    // );
    // _prayerTimesItems[10].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[10].date.day,
    //   0,
    //   0,
    //   50,
    // );
    // _prayerTimesItems[11].date = DateTime(
    //   2026,
    //   3,
    //   _prayerTimesItems[11].date.day,
    //   0,
    //   1,
    //   00,
    // );
    //

    MemoryCache.instance.create(key, _prayerTimesItems);

    changeSelectedTime();
  }

  void changeSelectedTime() {
    setState(() {
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
          _prayerTimesItems[i].isSelected = true;
          _prayerTimesItems[nextIndex].isNext = true;
          break;
        }

        if (_prayerTimesItems[i].index == 0) {
          if (_prayerTimesItems[i].date.isAfter(_date)) {
            _prayerTimesItems[5].isSelected = true;
            _prayerTimesItems[0].isNext = true;
            break;
          }
        }

        if (_prayerTimesItems[i].date.isBefore(_date) &&
            _prayerTimesItems[nextIndex].date.isAfter(_date)) {
          _prayerTimesItems[i].isSelected = true;
          _prayerTimesItems[nextIndex].isSelected = true;
          break;
        }
      }
    });
  }

  void calculateCountDown() {
    var nextTimeIndex = _prayerTimesItems.indexWhere((x) => x.isNext == true);

    var difference = _prayerTimesItems[nextTimeIndex].date.difference(_date);

    if (difference.isNegative || difference.inSeconds == 0) {
      changeSelectedTime();
      calculateCountDown();
    } else {
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      int seconds = difference.inSeconds % 60;

      setState(() {
        _countDownModel.hour = hours.toString().padLeft(2, '0');
        _countDownModel.minute = minutes.toString().padLeft(2, '0');
        _countDownModel.second = seconds.toString().padLeft(2, '0');
        _countDownModel.timeName = _prayerTimesItems[nextTimeIndex].name;
      });
    }

    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    loadPrayerTimes().then(
      (_) => {
        _timer = Timer.periodic(Duration(seconds: 1), (_) {
          setState(() {
            _date = DateTime.now();
            // _date.add(
            //   Duration(seconds: 1),
            // );
          });

          calculateCountDown();

          if (_date.day != _currentDate.day) {
            loadPrayerTimes();
            // _date = DateTime(_date.year, _date.month, _date.day, 23, 58, 00);
            _currentDate = _date;
          }
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
      mainAxisAlignment: _isLoading
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: !_isLoading
          ? [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Text(DateFormat("dd MMM yyyy").format(_date)),
                  Text('-'),
                  Text('20 Ramazan 1447'),
                ],
              ),
              SizedBox(height: 10),
              CountDown(
                colorScheme: colorScheme,
                countDownModel: _countDownModel,
              ),
              SizedBox(height: 10),
              PrayerTimesContainer(
                prayerTimesItems: _prayerTimesItems
                    .where((x) => x.date.day == _date.day)
                    .toList(),
                colorScheme: colorScheme,
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

class PrayerTimesContainer extends StatelessWidget {
  const PrayerTimesContainer({
    super.key,
    required List<PrayerTimesModel> prayerTimesItems,
    required this.colorScheme,
  }) : _prayerTimesItems = prayerTimesItems;

  final List<PrayerTimesModel> _prayerTimesItems;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 box yan yana
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2, // genişlik / yükseklik oranı, isteğe göre ayarla
      ),
      itemCount: _prayerTimesItems.length,
      itemBuilder: (context, index) {
        final item = _prayerTimesItems[index];
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: item.isSelected
                ? Border.all(
                    color: colorScheme.primary.withOpacity(0.8),
                    width: 1,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
            color: item.isSelected ? colorScheme.primaryFixed : Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.isSelected
                      ? colorScheme.primary
                      : colorScheme.secondaryFixed,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: SvgPicture.asset(
                  item.iconPath,
                  height: 24,
                  width: 24,
                  colorFilter: item.isSelected == true
                      ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : ColorFilter.mode(
                          colorScheme.secondary,
                          BlendMode.srcIn,
                        ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5, // dikey ortalama
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: item.isSelected
                          ? colorScheme.primary
                          : colorScheme.secondary,
                    ),
                  ),
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
      },
    );
  }
}

class CountDown extends StatelessWidget {
  const CountDown({
    super.key,
    required this.colorScheme,
    required CountdownModel countDownModel,
  }) : _countDownModel = countDownModel;

  final ColorScheme colorScheme;
  final CountdownModel _countDownModel;

  @override
  Widget build(BuildContext context) {
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
                  _countDownModel.timeName != null
                      ? '${_countDownModel.timeName} Vaktine Kalan'
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
                  _countDownModel.hour ?? '--',
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
                  _countDownModel.minute ?? '--',
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
                  _countDownModel.second ?? '--',
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
