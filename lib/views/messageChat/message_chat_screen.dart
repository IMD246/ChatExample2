// import 'package:flutter/material.dart';
// import 'package:flutter_basic_utilities/flutter_basic_utilities.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// class MessageChatScreen extends StatefulWidget {
//   const MessageChatScreen({
//     Key? key,
//     required this.socket,
//     required this.chatUserAndPresence,
//     required this.userInformation,
//   }) : super(key: key);
//   final Socket socket;
//   final UserInformation userInformation;
//   final ChatUserAndPresence chatUserAndPresence;

//   @override
//   State<MessageChatScreen> createState() => _MessageChatScreenState();
// }

// class _MessageChatScreenState extends State<MessageChatScreen> {
//   late String presence;
//   void startTimer(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       setState(() {
//         presence = differenceInCalendarDaysLocalization(
//           DateTime.parse(
//             widget.chatUserAndPresence.presence!.presenceTimeStamp!,
//           ),
//           context,
//         );
//       });
//     });
//   }

//   @override
//   void initState() {
//     startTimer(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final internetProvider = Provider.of<InternetProvider>(context);
//     final configProvider = Provider.of<ConfigAppProvider>(context);
//     // startTimer(context);
//     return BlocProvider<MessageBloc>(
//       create: (context) => MessageBloc(
//           MessageManager(
//             socket: widget.socket,
//             userPresence: widget.chatUserAndPresence.presence!,
//             chatMessageRepository: ChatMessageRepository(
//               baseUrl: configProvider.env.apiURL,
//             ),
//             user: widget.chatUserAndPresence.user!,
//             chat: widget.chatUserAndPresence.chat!,
//             ownerUserID: widget.userInformation.user!.sId!,
//           ),
//           widget.userInformation,
//           widget.chatUserAndPresence)
//         ..add(
//           InitializingMessageEvent(
//             chatUserAndPresence: widget.chatUserAndPresence,
//           ),
//         ),
//       child: BlocConsumer<MessageBloc, MessageState>(
//         listener: (context, state) {
//           if (state is LeavedChatMessageState) {
//             Navigator.of(context).pop();
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             appBar: buildAppbar(
//               context,
//               state.messageManager.streamUserPresence,
//               widget.chatUserAndPresence.chat!,
//               state.messageManager.streamUser,
//               state.userInformation,
//               internetProvider,
//             ),
//             body: BodyMessageChat(
//               messages: state.messageManager.streamListChatMessage,
//               chatUserAndPresence: widget.chatUserAndPresence,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   AppBar buildAppbar(
//       BuildContext context,
//       Stream<UserPresence> userPresence,
//       Chat chat,
//       Stream<User> user,
//       UserInformation userInformation,
//       InternetProvider internetProvider) {
//     return AppBar(
//       backgroundColor: Colors.greenAccent,
//       leading: BackButton(
//         color: Colors.black,
//         onPressed: () {
//           context.read<MessageBloc>().add(
//                 LeaveChatMessageEvent(
//                   chatID: chat.sId!,
//                   userID: userInformation.user!.sId.toString(),
//                 ),
//               );
//         },
//       ),
//       bottom: !internetProvider.isConnectedInternet
//           ? PreferredSize(
//               preferredSize: Size(
//                 20.w,
//                 20.h,
//               ),
//               child: Visibility(
//                 visible: !internetProvider.isConnectedInternet,
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: 4.0.h),
//                   child: textWidget(
//                     text: context.loc.waiting_internet,
//                     size: 15.h,
//                   ),
//                 ),
//               ),
//             )
//           : null,
//       title: Observer(
//         stream: userPresence,
//         onSuccess: (context, data) {
//           final userPresence = data;
//           return Row(
//             children: [
//               Stack(
//                 clipBehavior: Clip.none,
//                 alignment: AlignmentDirectional.bottomCenter,
//                 children: [
//                   Observer(
//                     stream: user,
//                     onSuccess: (context, data) {
//                       final user = data;
//                       return circleImageWidget(
//                         urlImage: user!.urlImage!.isNotEmpty
//                             ? user.urlImage!
//                             : "https://i.stack.imgur.com/l60Hf.png",
//                         radius: 20.w,
//                       );
//                     },
//                   ),
//                   if (userPresence?.presence == true) onlineIcon(),
//                 ],
//               ),
//               SizedBox(width: 8.w),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Observer(
//                     stream: user,
//                     onSuccess: (context, data) {
//                       final user = data;
//                       return textWidget(
//                         text: user?.name ?? "Unknown",
//                         size: 16.sp,
//                       );
//                     },
//                   ),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "${context.loc.online} ",
//                           style: TextStyle(
//                             fontSize: 16.sp,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         if (userPresence?.presence == false)
//                           TextSpan(
//                             text: presence,
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               color: Colors.black54,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
