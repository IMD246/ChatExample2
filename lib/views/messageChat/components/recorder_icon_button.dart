import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../StateManager/bloc/messageBloc/message_bloc.dart';
import '../../../StateManager/bloc/messageBloc/message_event.dart';
import '../../../constants/constant.dart';

class RecorderIconButton extends StatelessWidget {
  const RecorderIconButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<MessageBloc>().add(
              OpenRecorderEvent(),
            );
      },
      icon: const Icon(
        Icons.mic,
        color: kPrimaryColor,
      ),
    );
  }
}
