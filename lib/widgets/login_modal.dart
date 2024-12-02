import 'dart:ui';

import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/screens/child_screens/login.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:page_transition/page_transition.dart';

class LoginModal extends StatelessWidget {
  final BuildContext parentContext;

  const LoginModal({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: SimpleDialog(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        contentPadding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            LocaleKeys.youHaventSignedIn,
            style: TextStyle(
                color: Color.fromRGBO(85, 85, 85, 1),
                fontSize: 16.0,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w400),
          ).tr(),
          const SizedBox(
            height: 20.0,
          ),
          PrimaryButton(
              onPressed: () {
                Navigator.pop(context, true);
                Navigator.push(
                        parentContext,
                        PageTransition(
                            ctx: context,
                            type: PageTransitionType.fade,
                            child: LoginRoutePage(parentContext: context)))
                    .then((_) {});
              },
              child: LocaleKeys.login.tr())
        ],
      ),
    );
  }
}

void showLoginModal(BuildContext context) async {
  final bool? s = await showDialog(
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.55),
      context: context,
      builder: (context) => LoginModal(parentContext: context));
  if (s != true) {
    await Future.sync(() => BizhubRunner.restartApp(context));
  }
}
