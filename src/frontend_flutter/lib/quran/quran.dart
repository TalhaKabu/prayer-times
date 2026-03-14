import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_flutter/models/quran/surah_model.dart';
import 'package:frontend_flutter/models/quran/surah_with_info_model.dart';
import 'package:frontend_flutter/quran/childs/surah_list.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;

class QuranData {
  final List<SurahModel> surahs;
  final List<SurahWithInfoModel> surahsInfo;

  QuranData(this.surahs, this.surahsInfo);
}

class Quran extends StatefulWidget {
  const Quran({super.key});

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  List<SurahModel> _filteredSurahs = [];
  List<SurahModel> _surahs = [];
  final TextEditingController controller = TextEditingController();

  void _filterItems() {
    String query = controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = List.from(_surahs); // If empty, show all
      } else {
        _filteredSurahs = _surahs
            .where(
              (item) => unorm
                  .nfkd(item.translation.toLowerCase())
                  .contains(unorm.nfkd(query)),
            ) // Apply the filter
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_filterItems);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 50,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/search.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              // Text(
              //   'Sure veya ayet içeriği ara',
              //   style: TextStyle(color: colorScheme.secondary),
              // ),
              Expanded(
                child: Center(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Sure veya ayet içeriği ara',
                      isDense: true, // height’ı sıkıştırır
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: colorScheme.primary,
          ),
          child: Stack(
            children: [
              GestureDetector(
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/read.svg',
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          Text('HATİME BAŞLA', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "FATİHA SURESİ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight(600),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Ayet numarası: 1',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.secondaryFixed,
                        ),
                      ),
                      SizedBox(height: 15),
                      IntrinsicWidth(
                        child: GestureDetector(
                          onTap: () => {},
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 12,
                              bottom: 12,
                              left: 20,
                              right: 20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              spacing: 10,
                              children: [
                                Text(
                                  "Okumaya Başla",
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontSize: 20,
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/svgs/right_arrow.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    colorScheme.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: -10,
                child: SvgPicture.asset(
                  'assets/svgs/book_filled.svg',
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(
                    colorScheme.secondary.withOpacity(0.6),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SurahList(),
      ],
    );
  }
}
