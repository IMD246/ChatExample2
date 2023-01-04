import 'package:flutter/material.dart';
import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../StateManager/bloc/UpdateFullNameBloc/update_fullname_bloc.dart';
import '../../StateManager/bloc/UpdateFullNameBloc/update_fullname_event.dart';
import '../../constants/constant.dart';
import '../../extensions/localization.dart';
import '../../models/user_profile.dart';

class BodyUpdateInfoSetting extends StatefulWidget {
  const BodyUpdateInfoSetting({
    Key? key,
    required this.userProfile,
  }) : super(key: key);
  final UserProfile userProfile;
  @override
  State<BodyUpdateInfoSetting> createState() => _BodyUpdateInfoSettingState();
}

class _BodyUpdateInfoSettingState extends State<BodyUpdateInfoSetting> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateFullNameBloc = context.read<UpdateFullNameBloc>();
    Size size = MediaQuery.of(context).size;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isKeyboard)
            SizedBox(
              height: size.height * 0.05,
            ),
          StreamBuilder<String>(
            stream: updateFullNameBloc.firstNameStream,
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(
                    20.w,
                  ),
                ),
                child: TextFieldWidget(
                  borderRadius: 20.w,
                  controller: firstNameController,
                  hintText: context.loc.enter_your_first_name,
                  isShowSearchButton: false,
                  errorText: snapshot.data != null
                      ? snapshot.data == ""
                          ? null
                          : snapshot.data
                      : snapshot.data,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (value) {},
                  onChanged: (value) {
                    updateFullNameBloc.add(
                      UpdateFirstNameEvent(
                        value: value,
                      ),
                    );
                  },
                  onDeleted: () {
                    updateFullNameBloc.add(
                      UpdateFirstNameEvent(
                        value: "",
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          StreamBuilder<String>(
            stream: updateFullNameBloc.lastNameStream,
            builder: (context, snapshot) {
              return Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(
                    0.5,
                  ),
                  borderRadius: BorderRadius.circular(
                    20.w,
                  ),
                ),
                child: TextFieldWidget(
                  padding: 12.w,
                  hintText: context.loc.enter_your_last_name,
                  controller: lastNameController,
                  textInputAction: TextInputAction.done,
                  isShowSearchButton: false,
                  errorText: snapshot.data != null
                      ? snapshot.data == ""
                          ? null
                          : snapshot.data
                      : snapshot.data,
                  onSubmitted: (value) {},
                  onChanged: (value) {
                    updateFullNameBloc.add(
                      UpdateLastNameEvent(
                        value: value,
                      ),
                    );
                  },
                  onDeleted: () {
                    updateFullNameBloc.add(
                      UpdateLastNameEvent(
                        value: "",
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          StreamBuilder<bool>(
            stream: updateFullNameBloc.btnStream,
            initialData: false,
            builder: (context, snapshot) {
              final data = snapshot.data ?? false;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                child: FillOutlineButton(
                  color: data ? kPrimaryColor.withOpacity(0.5) : Colors.grey,
                  minWidth: double.infinity,
                  press: () {
                    if (data) {
                      updateFullNameBloc.add(
                        SubmitNewFullNameEvent(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                        ),
                      );
                      setState(() {
                        firstNameController.clear();
                        lastNameController.clear();
                      });
                    }
                  },
                  text: context.loc.update,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
