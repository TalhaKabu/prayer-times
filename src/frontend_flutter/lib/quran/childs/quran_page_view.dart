import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/models/quran/surah_model.dart';

List<SurahModel> parseSurahs(String jsonString) {
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => SurahModel.fromJson(e)).toList();
}

class QuranPageView extends StatefulWidget {
  const QuranPageView({required this.index, super.key});

  final int index;

  @override
  State<QuranPageView> createState() => _QuranPageViewState();
}

class _QuranPageViewState extends State<QuranPageView> {
  late Future<List<SurahModel>> _surahs;

  Future<List<SurahModel>> _loadSurah(int index) async {
    // if (QuranCache.ayahsBySurah.containsKey(surahId)) {
    //   return QuranCache.ayahsBySurah[surahId]!;
    // }

    final jsonString = await rootBundle.loadString(
      'assets/jsons/surah_list_tr.json',
    );

    final allSurahs = await compute(parseSurahs, jsonString);

    final surahAyahs = allSurahs.where((a) => a.id == index).toList();

    // QuranCache.ayahsBySurah[surahId] = surahAyahs;

    return surahAyahs;
  }

  @override
  void initState() {
    super.initState();
    _surahs = _loadSurah(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        centerTitle: true,
        title: Text(
          'Kuran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<SurahModel>>(
        future: _surahs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var verses = snapshot.data!.expand((x) => x.verses!).toList();

          return PageView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // <- bu çok önemli
            itemCount: 1,
            itemBuilder: (context, index) {
              return Placeholder();
            },
          );
        },
      ),
    );
  }
}
