import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/screens/child_screens/login.dart';
import 'package:bizhub/screens/child_screens/signup_process.dart';
import 'package:bizhub/screens/child_screens/verification.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';

class SignUpRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const SignUpRoutePage({super.key, required this.parentContext});

  @override
  State<SignUpRoutePage> createState() => _SignUpRoutePageState();
}

class _SignUpRoutePageState extends State<SignUpRoutePage> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.signUp.tr()),
      body: DefaultScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 10.0,
          ),
          CustomizedTextField(
            label: "${LocaleKeys.enterYourPhoneNumber.tr()}:",
            prefixText: "+993 ",
            controller: phoneController,
          ),
          const SizedBox(
            height: 25.0,
          ),
          PrimaryButton(
              onPressed: () async {
                final String phone = phoneController.text;

                final bool? s = await Navigator.push(
                    context,
                    PageTransition(
                        ctx: context,
                        type: PageTransitionType.fade,
                        child: VerificationRoutePage(
                          phone: "+993$phone",
                          parentContext: context,
                        )));

                if (s == true) {
                  Future.sync(() => Navigator.push(
                      context,
                      PageTransition(
                          ctx: context,
                          type: PageTransitionType.fade,
                          child: SignupProcessRoutePage(
                            phoneNumber: phone,
                            parentContext: context,
                          ))));
                }
              },
              child: tr(LocaleKeys.getVerificationCode)),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.dontHaveAnAccount.tr(),
                style: const TextStyle(fontSize: 17.0),
              ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          ctx: context,
                          type: PageTransitionType.fade,
                          child: LoginRoutePage(parentContext: context)));
                },
                child: Text(
                  LocaleKeys.login.tr(),
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
