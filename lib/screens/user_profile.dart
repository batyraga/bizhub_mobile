import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/gradients/bg_linear.gradient.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/main.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
          title: LocaleKeys.profile.tr(),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: const Image(
                        height: 50,
                        width: 50,
                        image: AssetImage("assets/images/profile.png")),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "User",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text("+993 61 026168",
                          style: TextStyle(color: Colors.grey))
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: bgLinearGradient,
                    borderRadius: BorderRadius.circular(20.0)),
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  const Text(
                    LocaleKeys.becomeSellerText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ).tr(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                ctx: context,
                                type: PageTransitionType.fade,
                                child: BecomeSellerRoutePage(
                                    parentContext: context)));
                      },
                      child: const Text(
                        LocaleKeys.continueAsSeller,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ).tr())
                ]),
              )
            ],
          ),
        ));
  }
}
