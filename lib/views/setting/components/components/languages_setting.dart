import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../StateManager/bloc/settingBloc/setting_bloc.dart';
import '../../../../StateManager/provider/language_provider.dart';
import '../../../../StateManager/provider/theme_provider.dart';
import '../../../../UIData/image_sources.dart';
import '../../../../extensions/localization.dart';
import '../../../../utilities/handle_value.dart';
import 'change_language.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final settingBloc = context.read<SettingBloc>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = UtilHandleValue.isDarkMode(themeProvider.themeMode);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return ChangeLanguage(
                userProfile: settingBloc.userProfile,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: const AssetImage(
                ImageSources.imgLanguage,
              ),
              backgroundColor: isDarkMode ? Colors.white : Colors.yellowAccent,
              radius: 20.w,
            ),
            SizedBox(width: 1.w),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: Column(
                children: [
                  Text(
                    context.loc.language,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    UtilHandleValue.getLanguage(
                      languageProvider.locale,
                      context,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
