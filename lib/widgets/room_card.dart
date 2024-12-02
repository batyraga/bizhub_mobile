import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/chat.model.dart';
import 'package:bizhub/providers/chat.service.dart';
import 'package:bizhub/screens/child_screens/messages/chat.dart';
import 'package:bizhub/widgets/custom_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RoomCard extends StatefulWidget {
  final ChatRoom room;
  final BuildContext parentContext;
  const RoomCard({
    Key? key,
    required this.parentContext,
    required this.room,
  }) : super(key: key);

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  LastChatRoomMessage? lastMessage;

  changeLastMessage(LastChatRoomMessage? m) {
    setState(() {
      lastMessage = m;
    });
  }

  @override
  void initState() {
    super.initState();

    lastMessage = widget.room.lastMessage;

    widget.parentContext.read<ChatService>().set<LastChatRoomMessage>(
        widget.room.id, "change-last-message", changeLastMessage);
  }

  @override
  void dispose() {
    widget.parentContext
        .read<ChatService>()
        .set(widget.room.id, "change-last-message", null);

    super.dispose();
  }

  void delete([bool? c]) async {
    bool b = c == true;
    if (b == false) {
      b = await showConfirmDialog(
          context, "Do you want delete this room in here?");
    }
    if (b == true) {
      Future.sync(() {
        context.read<ChatService>().deleteRoom(widget.room.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.room.id),
      startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
              closeOnCancel: true,
              confirmDismiss: () async {
                final bool b = await showConfirmDialog(
                    context, "Do you want delete this room in here?");
                return b;
              },
              onDismissed: () {
                delete(true);
              }),
          children: [
            SlidableAction(
              onPressed: (_) {
                delete();
              },
              backgroundColor: Colors.red,
              icon: Icons.delete_rounded,
              foregroundColor: Colors.white,
            ),
          ]),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  ctx: context,
                  type: PageTransitionType.fade,
                  child: ChatRoomRoutePage(
                      parentContext: widget.parentContext, room: widget.room)));
        },
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.red,
                foregroundImage:
                    CachedNetworkImageProvider("$cdnUrl${widget.room.logo}"),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  if (lastMessage != null)
                    Text(
                      lastMessage!.type == "text"
                          ? lastMessage!.text
                          : (lastMessage!.type == "product"
                              ? "Product"
                              : "Image"),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: Color.fromRGBO(110, 90, 209, 1),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
