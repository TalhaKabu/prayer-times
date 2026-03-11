import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_flutter/models/quran/quran_home_list_model.dart';
import 'package:frontend_flutter/quran/quran_childs/surah_list.dart';
import 'package:frontend_flutter/quran/quran_childs/quran_read.dart';
import 'package:frontend_flutter/quran/quran_childs/quran_translation.dart';

class QuranChilds extends StatefulWidget {
  final int selectedIndex;
  final QuranHomeModel quranHomeModel;
  const QuranChilds({
    required this.selectedIndex,
    required this.quranHomeModel,
    super.key,
  });

  @override
  State<QuranChilds> createState() => _QuranChildsState();
}

class _QuranChildsState extends State<QuranChilds> {
  void getSelectedIndex(int index) {
    setState(() {});
  }

  List<Widget> widgets = [QuranRead(), SurahList(), QuranTranslation()];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.onPrimaryFixedVariant,
        titleSpacing: 6,
        title: (Text(widget.quranHomeModel.name)),
        titleTextStyle: TextStyle(color: colorScheme.secondary, fontSize: 25),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            color: colorScheme.secondary,
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: SvgPicture.asset(
              'assets/svgs/back_button.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                colorScheme.secondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: widgets[widget.selectedIndex],
        ),
      ),
      // bottomNavigationBar: MyBottomNavBar(onSend: getSelectedIndex),
    );
  }
}
