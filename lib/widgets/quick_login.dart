import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/screens/child_screens/login.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:page_transition/page_transition.dart';

class QuickLogin extends StatelessWidget {
  const QuickLogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                        style: BorderStyle.solid)),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(LocaleKeys.youHaventSignedIn,
                            style: TextStyle(
                                color: Color.fromRGBO(85, 85, 85, 1),
                                fontSize: 16.0,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w400))
                        .tr(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    PrimaryButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  ctx: context,
                                  type: PageTransitionType.fade,
                                  child:
                                      LoginRoutePage(parentContext: context)));
                        },
                        child: LocaleKeys.login.tr()),
                  ],
                )),
          ],
        ));
  }
}
