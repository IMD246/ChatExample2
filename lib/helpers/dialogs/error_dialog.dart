import 'package:flutter/material.dart';

import 'generic_dialog.dart';
Future<void> showErrorDialog(
  {required BuildContext context,
  required String text,required String title}
  
) {
  return showGenericDialog<void>(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
