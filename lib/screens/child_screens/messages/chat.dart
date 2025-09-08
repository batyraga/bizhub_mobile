import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/chat.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/chat.service.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/widgets/chat_message_card.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ChatRoomRoutePage extends StatefulWidget {
  final ChatRoom room;
  final BuildContext parentContext;
  const ChatRoomRoutePage({
    Key? key,
    required this.room,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<ChatRoomRoutePage> createState() => _ChatRoomRoutePageState();
}

const _limit = 10;

class _ChatRoomRoutePageState extends State<ChatRoomRoutePage> {
  late String culture;

  final pagingController = PagingController<int, ChatMessage>(firstPageKey: 0);

  final ScrollController _controller = ScrollController();

  bool showScrollBottom = false;
  ChatMessageCommentOf? commentOf;

  void scrollDown() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void removeCommentOf() {
    setState(() {
      commentOf = null;
    });
  }

  @override
  void initState() {
    super.initState();

    culture = getLang(context);

    _controller.addListener(() {
      setState(() {
        showScrollBottom =
            _controller.offset != _controller.position.minScrollExtent;
      });
    });

    pagingController.addPageRequestListener((pageKey) async {
      await loadMessages(pageKey);
    });

    widget.parentContext.read<ChatService>().set<ChatMessage>(
          widget.room.id,
          "message",
          onMessage,
        );
    widget.parentContext.read<ChatService>().set<String>(
          widget.room.id,
          "delete-message",
          onDeleteMessage,
        );
  }

  void onMessage(ChatMessage? m) {
    if (m != null && pagingController.itemList != null) {
      final l = [...pagingController.itemList!];
      l.insertAll(0, [m]);
      pagingController.itemList = l;
    }
  }

  void onDeleteMessage(String? mId) {
    if (mId != null && pagingController.itemList != null) {
      pagingController.itemList = pagingController.itemList!
          .where((element) => element.id != mId)
          .toList();
    }
  }

  Future loadMessages(int page) async {
    try {
      List<ChatMessage> result = await api.chat.getRoomMessages(
        page: page,
        limit: _limit,
        room: widget.room.id,
        culture: culture,
      );

      // result = result.reversed.toList();
      if (result.length < _limit) {
        pagingController.appendLastPage(result);
      } else {
        pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      pagingController.error = err;
      log("[loadMessages] - error - $err");
    }
  }

  @override
  void dispose() {
    widget.parentContext.read<ChatService>().set<ChatMessage>(
          widget.room.id,
          "message",
          null,
        );
    widget.parentContext.read<ChatService>().set<String>(
          widget.room.id,
          "delete-message",
          null,
        );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cId = context.watch<Auth>().currentUser?.id;

    if (cId == null) {
      return Scaffold(
        appBar: DefaultAppBar(title: LocaleKeys.chat.tr()),
      );
    }

    return Scaffold(
      appBar: ChatRoomAppBar(room: widget.room),
      body: Column(
        children: [
          Expanded(
            child: PagedListView.separated(
                scrollController: _controller,
                reverse: true,
                shrinkWrap: true,
                pagingController: pagingController,
                padding: const EdgeInsets.all(15.0),
                builderDelegate: PagedChildBuilderDelegate<ChatMessage>(
                    itemBuilder: (context, item, index) {
                  return ChatMessageCard(
                      onAction: (s) async {
                        if (s == "delete") {
                          context
                              .read<ChatService>()
                              .deleteMessage(widget.room.id, item.id);
                        } else if (s == "comment") {
                          setState(() {
                            commentOf = ChatMessageCommentOf(
                                id: item.id,
                                content: ChatMessageContentCommentOf(
                                    text: item.content.text,
                                    imagePath: item.content.imagePath,
                                    product: item.content.product != null
                                        ? ChatMessageContentProductCommentOf(
                                            id: item.content.product!.id,
                                            text: item.content.product!.text)
                                        : null),
                                type: item.type);
                          });
                        } else if (s == "copy") {
                          if (item.type == "text") {
                            await Clipboard.setData(
                                ClipboardData(text: item.content.text??''));
                          }
                        }
                      },
                      message: item,
                      isMe: cId == item.sender);
                }),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 15.0,
                  );
                }),
          ),
          ChatRoomSendBox(
            roomId: widget.room.id,
            commentOf: commentOf,
            removeCommentOf: removeCommentOf,
          ),
        ],
      ),
      floatingActionButton: showScrollBottom
          ? Padding(
              padding:
                  EdgeInsets.only(bottom: commentOf == null ? 70.0 : 120.0),
              child: FloatingActionButton(
                mini: true,
                onPressed: scrollDown,
                child: const Icon(Icons.arrow_downward_rounded),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

final chatRoomSendBoxTextFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(100.0),
  gapPadding: 0.0,
  borderSide: const BorderSide(color: Colors.black),
);

class ChatRoomSendBox extends StatefulWidget {
  final String roomId;
  final ChatMessageCommentOf? commentOf;
  final void Function() removeCommentOf;
  const ChatRoomSendBox({
    Key? key,
    required this.roomId,
    required this.removeCommentOf,
    this.commentOf,
  }) : super(key: key);

  @override
  State<ChatRoomSendBox> createState() => _ChatRoomSendBoxState();
}

class _ChatRoomSendBoxState extends State<ChatRoomSendBox> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();

  Future sendMessage() async {
    textFocusNode.unfocus();

    final String text = textController.text.trim();
    log("[chat] - text - $text");
    if (text.isEmpty) {
      return;
    }

    context
        .read<ChatService>()
        .sendMessage(widget.roomId, text, widget.commentOf);

    textController.clear();

    widget.removeCommentOf();
  }

  Future sendImage() async {
    textFocusNode.unfocus();

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    try {
      final String imagePath = await api.chat.uploadImage(File(image.path));

      Future.sync(() {
        context.read<ChatService>().sendImage(widget.roomId, imagePath);
      });
    } catch (err) {
      log("[chatSendImage] - error - $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.commentOf != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 5.0,
            ),
            decoration: const BoxDecoration(
                color: Color.fromRGBO(241, 241, 255, 1),
                border: Border(
                    top: BorderSide(color: Color.fromRGBO(229, 229, 229, 1)))),
            child: Row(
              children: [
                Expanded(
                  child: widget.commentOf!.type == "image"
                      ? Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(229, 229, 229, 1)),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "$cdnUrl${widget.commentOf!.content.imagePath}",
                                  height: 50.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            const Text('image',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                )).tr()
                          ],
                        )
                      : Text(
                          widget.commentOf!.type == "text"
                              ? widget.commentOf!.content.text!
                              : widget.commentOf!.content.product!.text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                InkWell(
                  onTap: widget.removeCommentOf,
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(247, 248, 250, 1),
              border: Border(
                  top: BorderSide(color: Color.fromRGBO(229, 229, 229, 1)))),
          child: Row(
            children: [
              if (widget.commentOf == null)
                InkWell(
                    onTap: sendImage,
                    child: const Icon(
                      Icons.image_rounded,
                      size: 20.0,
                    )),
              if (widget.commentOf == null)
                const SizedBox(
                  width: 15.0,
                ),
              Expanded(
                child: SizedBox(
                  height: 40.0,
                  child: TextField(
                    controller: textController,
                    focusNode: textFocusNode,
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15.0),
                        fillColor: Colors.white,
                        border: chatRoomSendBoxTextFieldBorder,
                        focusedBorder: chatRoomSendBoxTextFieldBorder,
                        disabledBorder: chatRoomSendBoxTextFieldBorder,
                        errorBorder: chatRoomSendBoxTextFieldBorder,
                        enabledBorder: chatRoomSendBoxTextFieldBorder),
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              InkWell(
                  onTap: sendMessage,
                  child: const Icon(
                    Icons.send_rounded,
                    size: 20.0,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class ChatRoomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ChatRoom room;
  const ChatRoomAppBar({Key? key, required this.room})
      : preferredSize = const Size.fromHeight(62),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0;

  @override
  State<ChatRoomAppBar> createState() => _ChatRoomAppBarState();
}

class _ChatRoomAppBarState extends State<ChatRoomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).viewPadding.top,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
              color: Color.fromRGBO(247, 248, 250, 1),
              border: Border(
                  bottom: BorderSide(color: Color.fromRGBO(229, 229, 229, 1)))),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              const SizedBox(
                width: 15.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.red,
                foregroundImage:
                    CachedNetworkImageProvider("$cdnUrl${widget.room.logo}"),
                radius: 20.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                widget.room.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
