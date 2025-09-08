import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/gradients/bg_linear.gradient.dart';
import 'package:bizhub/helpers/phone.dart';
import 'package:bizhub/models/user.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/main.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class NormalUserProfile extends StatefulWidget {
  const NormalUserProfile({super.key});

  @override
  State<NormalUserProfile> createState() => _NormalUserProfileState();
}

class _NormalUserProfileState extends State<NormalUserProfile> {
  @override
  Widget build(BuildContext context) {
    final User currentUser = context.watch<Auth>().currentUser!;
    final String formattedPhone = formatPhone(currentUser.phone);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                foregroundImage:
                    CachedNetworkImageProvider("$cdnUrl${currentUser.logo}"),
                child: currentUser.logo != null
                    ? const Image(
                        height: 50,
                        width: 50,
                        image: AssetImage("assets/images/profile.png"))
                    : null,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text("+993 $formattedPhone",
                      style: const TextStyle(color: Colors.grey))
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
                    elevation: 0.0,
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
                            child:
                                BecomeSellerRoutePage(parentContext: context)));
                  },
                  child: const Text(
                    LocaleKeys.continueAsSeller,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ).tr())
            ]),
          )
        ],
      ),
    );
  }
}
