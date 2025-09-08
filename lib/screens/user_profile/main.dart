import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/main.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/screens/user_profile/child_screens/edit_seller_profile.dart';
import 'package:bizhub/screens/user_profile/child_screens/set_api.dart';
import 'package:bizhub/screens/user_profile/normal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/screens/user_profile/seller_profile.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/gradients/bg_linear.gradient.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/screens/user_profile/child_screens/add_feedback.dart';
import 'package:bizhub/screens/user_profile/child_screens/add_post.dart';
import 'package:bizhub/screens/user_profile/child_screens/add_product.dart';
import 'package:bizhub/screens/user_profile/child_screens/edit_profile.dart';
import 'package:bizhub/screens/user_profile/child_screens/language.dart';
import 'package:bizhub/screens/user_profile/child_screens/notification.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/main.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/use_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<Auth>().isAuthenticated;
    final isSeller = context.watch<Auth>().isSeller;

    return Scaffold(
        appBar: DefaultAppBar(
          title: LocaleKeys.profile.tr(),
          actions: [
            if (isAuthenticated && isSeller)
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            ctx: context,
                            type: PageTransitionType.fade,
                            child: WalletRoutePage(parentContext: context)));
                  },
                  icon: const Icon(Icons.wallet_outlined)),
            if (isAuthenticated && isSeller)
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: _addModalBottomSheet,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0))));
                  },
                  icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: _optionsModalBottomSheet,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0))));
                },
                icon: const Icon(Icons.more_horiz_outlined))
          ],
        ),
        body: UseAuth(
            child: context.watch<Auth>().isSeller
                ? MySellerProfile(parentContext: context)
                : const NormalUserProfile()));
  }
}

Widget _addModalBottomSheet(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: ListView(
        shrinkWrap: true,
        children: [
          BottomSheetButton(
            icon: const Icon(Icons.add_outlined),
            title: LocaleKeys.addProduct.tr(),
            onTap: () async {
              final bool? status = await Navigator.push(
                  context,
                  PageTransition(
                      ctx: context,
                      type: PageTransitionType.fade,
                      child: AddProductRoutePage(parentContext: context)));

              if (status == true) {
                globalEvents.emit("profile:products:refresh");
              }

              Future.sync(() => Navigator.pop(context));
            },
          ),
          BottomSheetButton(
            icon: const Icon(Icons.post_add_outlined),
            title: LocaleKeys.addPost.tr(),
            onTap: () async {
              final bool? status = await Navigator.push(
                  context,
                  PageTransition(
                      ctx: context,
                      type: PageTransitionType.fade,
                      child: AddPostRoutePage(parentContext: context)));

              if (status == true) {
                globalEvents.emit("profile:posts:refresh");
              }

              Future.sync(() => Navigator.pop(context));
            },
          ),
        ],
      ));
}

Widget _optionsModalBottomSheet(BuildContext context) {
  final isAuthenticated = context.watch<Auth>().isAuthenticated;
  final isSeller = context.watch<Auth>().isSeller;
  void closeParent() {
    Navigator.pop(context);
  }

  return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: ListView(
        shrinkWrap: true,
        children: [
          BottomSheetButton(
            icon: const Icon(Icons.abc_outlined),
            title: "Set Server Ip Address",
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      ctx: context,
                      type: PageTransitionType.fade,
                      child: const SetApiRoutePage()));
            },
          ),
          if (isAuthenticated)
            BottomSheetButton(
              icon: const Icon(Icons.edit_outlined),
              title: LocaleKeys.editProfile.tr(),
              onTap: () {
                if (context.read<Auth>().isSeller) {
                  globalEvents.emit("profile:edit");
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          ctx: context,
                          type: PageTransitionType.fade,
                          child: EditProfileRoutePage(parentContext: context)));
                  Navigator.pop(context);
                }
              },
            ),
          BottomSheetButton(
            icon: const Icon(Icons.notifications_outlined),
            title: LocaleKeys.notification.tr(),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      ctx: context,
                      type: PageTransitionType.fade,
                      child: NotificationRoutePage(parentContext: context)));
            },
          ),
          BottomSheetButton(
            icon: const Icon(Icons.language_outlined),
            title: LocaleKeys.language.tr(),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) =>
                      LanguageModalBottomSheet(parentContext: context),
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0))));
            },
          ),
          BottomSheetButton(
            icon: const Icon(Icons.task_alt_rounded),
            title: LocaleKeys.termsOfUse.tr(),
            onTap: () {},
          ),
          BottomSheetButton(
            icon: const Icon(Icons.security_outlined),
            title: LocaleKeys.privacyPolicy.tr(),
            onTap: () {},
          ),
          BottomSheetButton(
            icon: const Icon(Icons.contact_support_outlined),
            title: LocaleKeys.support.tr(),
            onTap: () {},
          ),
          if (isAuthenticated && isSeller)
            BottomSheetButton(
              icon: const Icon(Icons.feedback_outlined),
              title: LocaleKeys.addFeedback.tr(),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        ctx: context,
                        type: PageTransitionType.fade,
                        child: AddFeedbackRoutePage(
                            parentContext: context, closeParent: closeParent)));
              },
            ),
          if (isAuthenticated && isSeller)
            BottomSheetButton(
              icon: const Icon(Icons.qr_code_2_outlined),
              title: LocaleKeys.getQr.tr(),
              onTap: () {
                closeParent();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                          elevation: 0,
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          contentPadding: const EdgeInsets.all(20.0),
                          children: [
                            SizedBox(
                              width: 200,
                              child: QrImageView(
                                data: "bizhub by ojo team",
                                semanticsLabel: "ojo code",
                                dataModuleStyle: const QrDataModuleStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ));
              },
            ),
          BottomSheetButton(
            icon: const Icon(Icons.open_in_new),
            title: LocaleKeys.share.tr(),
            onTap: () async {
              final box = context.findRenderObject() as RenderBox?;

              await Share.share("Bizhub app download here https://google.com",
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size);
              closeParent();
            },
          ),
          if (isAuthenticated)
            BottomSheetButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              title: LocaleKeys.logout.tr(),
              onTap: () {
                // Navigator.pop(context);
                context.read<Auth>().logout();
                BizhubRunner.restartApp(context);
              },
              color: Colors.red,
            ),
        ],
      ));
}
