import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/models/quran/surah_model.dart';
import 'package:frontend_flutter/models/quran/surah_with_info_model.dart';

List<SurahModel> parseSurahs(String jsonString) {
  final List data = jsonDecode(jsonString);
  return data.map((e) => SurahModel.fromJson(e)).toList();
}

List<SurahWithInfoModel> parseSurahsWithInfo(String jsonString) {
  final List data = jsonDecode(jsonString);
  return data.map((e) => SurahWithInfoModel.fromJson(e)).toList();
}

class SurahList extends StatefulWidget {
  const SurahList({super.key});

  @override
  State<SurahList> createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> {
  late Future<List<dynamic>> _allData;

  Future<List<SurahModel>> loadSurahs() async {
    final jsonString = await rootBundle.loadString(
      'assets/jsons/quran_tr.json',
    );
    // compute ile parse ediyoruz → ana thread takılmaz
    return compute(parseSurahs, jsonString);
  }

  Future<List<SurahWithInfoModel>> loadSurahsWithInfo() async {
    final jsonString = await rootBundle.loadString(
      'assets/jsons/quran_uthmani.json',
    );
    // compute ile parse ediyoruz → ana thread takılmaz
    return compute(parseSurahsWithInfo, jsonString);
  }

  @override
  void initState() {
    super.initState();
    _allData = Future.wait([loadSurahs(), loadSurahsWithInfo()]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FutureBuilder(
      future: _allData,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text("Hata: ${asyncSnapshot.error}"));
        } else if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
          return const Center(child: Text("Veri yok"));
        }

        final surahs = asyncSnapshot.data![0] as List<SurahModel>;
        final surahsWithInfo =
            asyncSnapshot.data![1] as List<SurahWithInfoModel>;

        return ListView.builder(
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            var surah = surahs[index];
            var surahWithInfo = surahsWithInfo[index];
            // var surahWithInfo = surahsWithInfo[index];
            return GestureDetector(
              onTap: () {
                print(surahWithInfo.englishName);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: index % 2 == 0
                        ? Colors.white
                        : colorScheme.primaryFixedDim,
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryFixed,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            surah.id.toString(),
                            style: TextStyle(color: Colors.black38),
                          ),
                        ),
                      ),
                      Column(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            surah.name,
                            style: TextStyle(color: colorScheme.secondary),
                          ),
                          Text(surah.translation),
                          DefaultTextStyle(
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontSize: 12,
                            ),
                            child: Row(
                              spacing: 2,
                              children: [
                                Text('${surah.totalVerses} ayet'),
                                Text('·'),
                                Text('${surahWithInfo.ayahs[0].juz}.cüz'),
                                Text('·'),
                                Text('${surahWithInfo.ayahs[0].page}.sayfa'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
