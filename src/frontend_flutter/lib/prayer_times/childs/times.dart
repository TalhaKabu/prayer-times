import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend_flutter/models/prayer_times/prayer_times_model.dart';
import 'package:intl/intl.dart';

class Times extends StatefulWidget {
  const Times({required this.prayerTimesItems, super.key});

  final List<PrayerTimesModel> prayerTimesItems;

  @override
  State<Times> createState() => _TimesState();
}

class _TimesState extends State<Times> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 box yan yana
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2, // genişlik / yükseklik oranı, isteğe göre ayarla
      ),
      itemCount: widget.prayerTimesItems.length,
      itemBuilder: (context, index) {
        final item = widget.prayerTimesItems[index];
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
                    DateFormat('dd.MM HH:mm:ss').format(item.date),
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
