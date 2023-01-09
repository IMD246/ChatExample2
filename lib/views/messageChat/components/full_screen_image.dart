import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import '../../../models/user_profile.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({
    Key? key,
    required this.urlImage,
    required this.userProfile,
  }) : super(key: key);
  final String urlImage;
  final UserProfile? userProfile;
  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                Center(
                  child: PhotoView(
                    imageProvider: Image.network(
                      widget.urlImage,
                      fit: BoxFit.fill,
                    ).image,
                  ),
                ),
                Visibility(
                  visible: isSelected,
                  child: Positioned(
                    top: 5,
                    left: 0,
                    child: Row(
                      children: [
                        const BackButton(
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          widget.userProfile?.fullName ?? "Unknown",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
