import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/main.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';

class SellerOptionalInfosTab extends StatefulWidget {
  const SellerOptionalInfosTab({super.key});

  @override
  State<SellerOptionalInfosTab> createState() => _SellerOptionalInfosTabState();
}

class _SellerOptionalInfosTabState extends State<SellerOptionalInfosTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${LocaleKeys.moreAboutYou.tr()}:",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ReactiveTextField(
                keyboardType: TextInputType.text,
                formControlName: "bio",
                maxLines: 4,
                onSubmitted: (_) {
                  ReactiveForm.of(context)?.unfocus();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
