import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/models/quran/surah_model.dart';

List<SurahModel> parseSurahs(String jsonString) {
  List data = jsonDecode(jsonString);
  data = data.take(10).toList();
  return data.map((e) => SurahModel.fromJson(e)).toList();
}

class SurahList extends StatefulWidget {
  const SurahList({super.key});

  @override
  State<SurahList> createState() => _SurahListState();
}

class _SurahListState extends State<SurahList> {
  late Future<List<SurahModel>> _surahNames;
  final TextEditingController controller = TextEditingController();

  Future<List<SurahModel>> loadSurahs() async {
    final jsonString = await rootBundle.loadString(
      'assets/jsons/surah_names_tr.json',
    );
    // compute ile parse ediyoruz → ana thread takılmaz
    return compute(parseSurahs, jsonString);
  }

  @override
  void initState() {
    super.initState();
    _surahNames = loadSurahs();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: FutureBuilder(
        future: _surahNames,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (asyncSnapshot.hasError) {
            return Center(child: Text("Hata: ${asyncSnapshot.error}"));
          } else if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
            return const Center(child: Text("Veri yok"));
          }

          final surahs = asyncSnapshot.data!;

          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              var surah = surahs[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: index % 2 == 0 ? Colors.white : Colors.white,
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Column(
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
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah.translation,
                              style: TextStyle(fontWeight: FontWeight(600)),
                            ),
                            DefaultTextStyle(
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontSize: 12,
                              ),
                              child: Row(
                                spacing: 2,
                                children: [
                                  Text(
                                    surah.type == 'meccan' ? 'Mekke' : 'Medine',
                                  ),
                                  Text('-'),
                                  Text('${surah.totalVerses} ayet'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              surah.name,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 20,
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
      ),
    );
  }
}
