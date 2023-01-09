import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageFileWidget extends StatelessWidget {
  const ImageFileWidget({super.key, this.urlImage});
  final String? urlImage;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40.sp),
      child: Image.file(
        fit: BoxFit.cover,
        File(
          urlImage ?? "",
        ),
      ),
    );
  }
}
