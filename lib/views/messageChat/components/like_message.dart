import 'package:flutter/material.dart';

import '../../../UIData/image_sources.dart';

class LikeMessage extends StatelessWidget {
  const LikeMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageSources.icLike,
      fit: BoxFit.cover,
    );
  }
}
