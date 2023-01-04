import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../StateManager/provider/language_provider.dart';
import '../../../../extensions/localization.dart';
import '../../../../models/user_profile.dart';
import 'language_radio.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key, required this.userProfile}) : super(key: key);
  final UserProfile userProfile;
  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          context.loc.language,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 20.h,
        ),
        child: Column(
          children: [
            Row(
              children: [
                LanguageRadio(
                  value: "vi_VN",
                  groupValue: languageProvider.locale.toString(),
                  onChanged: (val) async {
                    await languageProvider.changeLocale(
                      language: val,
                      userID: widget.userProfile.id!,
                    );
                  },
                ),
                Text(context.loc.vietnamese),
              ],
            ),
            Row(
              children: [
                LanguageRadio(
                  value: "en_US",
                  groupValue: languageProvider.locale.toString(),
                  onChanged: (val) async {
                    await languageProvider.changeLocale(
                      language: val,
                      userID: widget.userProfile.id!,
                    );
                  },
                ),
                Text(context.loc.english),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
