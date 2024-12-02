import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/chat.model.dart';
import 'package:bizhub/providers/chat.service.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/room_card.dart';
import 'package:flutter/material.dart';
// import 'package:bizhub/screens/child_screens/messages/chat.dart.txt';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MessagesRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const MessagesRoutePage({super.key, required this.parentContext});

  @override
  State<MessagesRoutePage> createState() => _MessagesRoutePageState();
}

const _limit = 10;

class _MessagesRoutePageState extends State<MessagesRoutePage> {
  late String culture;
  final pagingController = PagingController<int, ChatRoom>(firstPageKey: 0);

  Future onRefresh() async {
    pagingController.refresh();
  }

  void l(int nextPage) async {
    try {
      final result = await api.chat.getRooms(
        culture: culture,
        page: nextPage,
        limit: _limit,
      );
      if (result.length < _limit) {
        pagingController.appendLastPage(result);
      } else {
        pagingController.appendPage(result, nextPage + 1);
      }
    } catch (err) {
      log("[loadRooms] - error - $err");
      pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  // onChangeLastMessageOfRoom(String roomId, LastChatRoomMessage m) {
  //   final index = pagingController.itemList
  //       ?.indexWhere((element) => element.id == roomId);
  //   if (index != -1 && index != null) {
  //     pagingController.itemList = pagingController.itemList!.map((e) {
  //       if (e.id == roomId) {
  //         e.lastMessage = m;
  //       }
  //       return e;
  //     }).toList();
  //   }
  // }

  void onDeleteRoom(String room) {
    if (pagingController.itemList != null) {
      pagingController.itemList = pagingController.itemList!
          .where((element) => element.id != room)
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();

    culture = getLang(context);

    pagingController.addPageRequestListener(l);
    context.read<ChatService>().setNewRoomCreateListener(onRefresh);
    context.read<ChatService>().setDeleteRoomListener(onDeleteRoom);
  }

  // @override
  // void dispose() {
  //   context.read<ChatService>().setNewRoomCreateListener(null);

  //   // pagingController.removePageRequestListener(l);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.messages.tr(),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: PagedListView(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
              itemBuilder: (context, item, index) {
            return RoomCard(
              room: item,
              parentContext: widget.parentContext,
            );
          }),
        ),
      ),
    );
  }
}
// Dismissible(
//   key: const Key("i-1"),
//   child: InkWell(
//     onTap: () {},
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(100.0),
//                 child: const Image(
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                   image: AssetImage(
//                     "assets/images/xiaomi.png",
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 15.0,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text("Honor Smartphones",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16.0)),
//                   SizedBox(
//                     height: 6.0,
//                   ),
//                   Text("Sent phone",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           overflow: TextOverflow.ellipsis,
//                           fontSize: 14.0,
//                           color: Color.fromRGBO(151, 151, 190, 1))),
//                 ],
//               )
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5.0),
//                     color: Theme.of(context).colorScheme.secondary),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 5, vertical: 2),
//                 child: const Text(
//                   "3",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(
//                 height: 10.0,
//               ),
//               const Text(
//                 "18:01",
//                 style: TextStyle(
//                     fontSize: 12.0,
//                     color: Color.fromRGBO(151, 151, 190, 1)),
//               )
//             ],
//           )
//         ],
//       ),
//     ),
//   ),
// ),
// InkWell(
//   onTap: () {},
//   child: Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(100.0),
//               child: const Image(
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//                 image: AssetImage(
//                   "assets/images/xiaomi.png",
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 15.0,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text("Honor Smartphones",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16.0)),
//                 SizedBox(
//                   height: 6.0,
//                 ),
//                 Text("Sent phone",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         overflow: TextOverflow.ellipsis,
//                         fontSize: 14.0,
//                         color: Color.fromRGBO(151, 151, 190, 1))),
//               ],
//             )
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5.0),
//                   color: Theme.of(context).colorScheme.secondary),
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 5, vertical: 2),
//               child: const Text(
//                 "3",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               height: 10.0,
//             ),
//             const Text(
//               "18:01",
//               style: TextStyle(
//                   fontSize: 12.0,
//                   color: Color.fromRGBO(151, 151, 190, 1)),
//             )
//           ],
//         )
//       ],
//     ),
//   ),
// )

