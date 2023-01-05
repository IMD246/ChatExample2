import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget onlineIcon({
  double? width,
  double? height,
  double? bottom,
  double? right,
  double? padding,
}) {
  return Positioned(
    bottom: bottom ?? -1,
    right: right ?? 0,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(padding ?? 2.w),
      child: Container(
        width: width ?? 10.w,
        height: height ?? 10.h,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
    ),
  );
}
