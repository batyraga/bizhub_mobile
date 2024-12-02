import 'dart:ui';

import 'package:bizhub/config/api.dart';
import 'package:bizhub/models/chat.model.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatMessageCardCommentOf extends StatefulWidget {
  final ChatMessageCommentOf message;
  const ChatMessageCardCommentOf({Key? key, required this.message})
      : super(key: key);

  @override
  State<ChatMessageCardCommentOf> createState() =>
      _ChatMessageCardCommentOfState();
}

class _ChatMessageCardCommentOfState extends State<ChatMessageCardCommentOf> {
  @override
  Widget build(BuildContext context) {
    if (widget.message.type != "image") {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(180, 180, 222, 1),
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          widget.message.type == "text"
              ? widget.message.content.text!
              : widget.message.content.product!.text,
          style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(26, 26, 62, 1)),
        ),
      );
    } else if (widget.message.type == "image") {
      return Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(142, 142, 223, 1)),
            borderRadius: BorderRadius.circular(5.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: CachedNetworkImage(
              imageUrl: "$cdnUrl${widget.message.content.imagePath}"),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class ChatMessageCard extends StatefulWidget {
  final ChatMessage message;
  final bool isMe;
  final void Function(String) onAction;
  const ChatMessageCard({
    Key? key,
    required this.isMe,
    required this.onAction,
    required this.message,
  }) : super(key: key);

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  void openMessageOptions() async {
    final String? action = await showCustomModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.message.type == "text")
                BottomSheetButton(
                  title: "Copy",
                  onTap: () {
                    Navigator.pop(context, "copy");
                  },
                ),
              BottomSheetButton(
                title: "Comment",
                onTap: () {
                  Navigator.pop(context, "comment");
                },
              ),
              BottomSheetButton(
                title: "Delete",
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context, "delete");
                },
              ),
            ],
          );
        });

    if (action != null) {
      widget.onAction(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: openMessageOptions,
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.message.type != "image")
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              decoration: BoxDecoration(
                  color: widget.isMe
                      ? const Color.fromRGBO(241, 241, 255, 1)
                      : const Color.fromRGBO(142, 142, 223, 1),
                  borderRadius: BorderRadius.circular(5.0)),
              child: widget.message.type == "text"
                  ? Column(
                      crossAxisAlignment: widget.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (widget.message.commentOf != null)
                          ChatMessageCardCommentOf(
                              message: widget.message.commentOf!),
                        if (widget.message.commentOf != null)
                          const SizedBox(
                            height: 10.0,
                          ),
                        Text(
                          widget.message.content.text!,
                          textAlign:
                              widget.isMe ? TextAlign.right : TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: widget.isMe
                                  ? const Color.fromRGBO(26, 26, 62, 1)
                                  : Colors.white),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: widget.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.message.content.product!.detail != null)
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0)),
                            width: 170.0,
                            height: 260.0,
                            child: ProductCard(
                                product:
                                    widget.message.content.product!.detail!),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.red,
                            ),
                            child: const Text(
                              "Deleted product",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.message.content.product!.text,
                          textAlign:
                              widget.isMe ? TextAlign.right : TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: widget.isMe
                                  ? const Color.fromRGBO(26, 26, 62, 1)
                                  : Colors.white),
                        ),
                      ],
                    ),
            ),
          if (widget.message.type == "image")
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color.fromRGBO(142, 142, 223, 1)),
                  borderRadius: BorderRadius.circular(5.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: CachedNetworkImage(
                    imageUrl: "$cdnUrl${widget.message.content.imagePath}"),
              ),
            ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
              "${widget.message.createdAt.hour.toString().padLeft(2, "0")}:${widget.message.createdAt.minute.toString().padLeft(2, "0")}")
        ],
      ),
    );
  }
}
