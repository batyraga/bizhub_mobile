import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';

class AddFeedbackRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final void Function() closeParent;
  const AddFeedbackRoutePage(
      {super.key, required this.parentContext, required this.closeParent});

  @override
  State<AddFeedbackRoutePage> createState() => _AddFeedbackRoutePageState();
}

class _AddFeedbackRoutePageState extends State<AddFeedbackRoutePage> {
  final TextEditingController messageController = TextEditingController();

  Future<void> onSubmit() async {
    final String trimmedMessage = messageController.value.text.trim();

    try {
      final bool isSuccess = await api.feedbacks.addFeedback(
        message: trimmedMessage,
      );

      if (isSuccess) {
        Future.sync(() {
          Navigator.pop(widget.parentContext);
          // widget.closeParent(); // closes bottom sheet
          showDialog(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    contentPadding: const EdgeInsets.all(20.0),
                    children: [
                      const Text(
                        "Thank you!",
                        style: TextStyle(
                            fontSize: 19, color: Color.fromRGBO(85, 85, 85, 1)),
                      ),
                      Text(
                        LocaleKeys.thankYouForFeedback.tr(),
                        // "This is very valuable for us.",
                        style: const TextStyle(
                            fontSize: 19, color: Color.fromRGBO(85, 85, 85, 1)),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      PrimaryButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: LocaleKeys.ok.tr())
                    ],
                  ));
        });
        return;
      }
    } catch (err) {
      log("[addFeedback] - error - $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(title: LocaleKeys.addFeedback.tr()),
        body: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.yourMessage.tr(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: messageController,
                  maxLines: 4,
                  validator: (value) {
                    if (value?.isNotEmpty == true) {
                      return "Please enter your message";
                    }
                  },
                  style: const TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15.0),
                    border: textFieldBorder(context),
                    enabledBorder: textFieldBorder(context),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            PrimaryButton(onPressed: onSubmit, child: LocaleKeys.send.tr())
          ],
        ));
  }
}
