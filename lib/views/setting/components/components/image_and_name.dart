import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/widgets/circle_image_widget.dart';
import 'package:flutter_basic_utilities/widgets/text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../StateManager/bloc/settingBloc/setting_bloc.dart';
import '../../../../StateManager/bloc/settingBloc/setting_event.dart';
import '../../../../extensions/localization.dart';
import '../../../../models/user_profile.dart';

class ImageAndName extends StatelessWidget {
  const ImageAndName({
    Key? key,
    required this.userProfile,
  }) : super(key: key);
  final UserProfile userProfile;
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final settingBloc = context.read<SettingBloc>();
    return Column(
      children: [
        SizedBox(
          height: 16.h,
        ),
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              StreamBuilder<String?>(
                stream: settingBloc.remoteStorageRepository
                    .getFile(
                      filePath: "userProfile",
                      fileName: settingBloc.userProfile.id!,
                    )
                    .asStream(),
                builder: (context, snapshot) {
                  return circleImageWidget(
                    urlImage:
                        snapshot.data ?? "https://i.stack.imgur.com/l60Hf.png",
                    radius: 60.h,
                  );
                },
              ),
              Positioned(
                bottom: 3.h,
                right: 3.w,
                child: GestureDetector(
                  onTap: () async {
                    final result = await _uploadImageProfile(context);
                    if (result == null) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            context.loc.no_file_selected,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      settingBloc.add(
                        UpdateImageSettingEvent(
                          filePickerResult: result,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white54,
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 32.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        textWidget(
          text: userProfile.fullName,
          fontWeight: FontWeight.bold,
          size: 20.h,
        ),
      ],
    );
  }

  Future<FilePickerResult?> _uploadImageProfile(BuildContext context) async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
        'PNG',
      ],
    );
    return results;
  }
}
