import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/quran/quran_home_list_model.dart';
import 'package:frontend_flutter/quran/quran_childs/quran_childs.dart';

class Quran extends StatefulWidget {
  const Quran({super.key});

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: List.generate(quranHomeModelList.length, (index) {
        return GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuranChilds(
                  selectedIndex: index,
                  quranHomeModel: quranHomeModelList[index],
                ),
              ),
            ),
          },
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Row(
              spacing: 10,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: colorScheme.secondaryFixed,
                  ),
                  child: Text((index + 1).toString()),
                ),
                Text(quranHomeModelList[index].name),
              ],
            ),
          ),
        );
      }),
    );
  }
}
