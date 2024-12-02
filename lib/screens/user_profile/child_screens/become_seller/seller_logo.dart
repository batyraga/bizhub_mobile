import 'dart:io';

import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SellerLogoTab extends StatefulWidget {
  const SellerLogoTab({super.key});

  @override
  State<SellerLogoTab> createState() => _SellerLogoTabState();
}

class _SellerLogoTabState extends State<SellerLogoTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Center(
          child: Stack(children: [
            Positioned(
              top: MediaQuery.of(context).size.width * -0.15,
              right: MediaQuery.of(context).size.width * -0.25,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500.0),
                    color: const Color.fromRGBO(255, 199, 0, 1)),
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width * 1.5,
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).size.width * 0.2,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (MediaQuery.of(context).size.width / 7)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.asset(
                                "assets/images/jeff-bezos.png",
                                width: 80.0,
                                height: 80.0,
                              ),
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.becomeSellerSagiHavivName.tr(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  LocaleKeys.becomeSellerSagiHavivRole.tr(),
                                  style: const TextStyle(
                                      color: Color.fromRGBO(85, 85, 85, 1),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          LocaleKeys.becomeSellerSagiHavivText.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        )),
        ReactiveValueListenableBuilder<File>(
            formControlName: "logo",
            builder: (context, field, child) {
              return Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${LocaleKeys.uploadLogo.tr()}:",
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () async {
                                final picker = ImagePicker();
                                final file = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (file != null) {
                                  setState(() {
                                    field.value = File(file.path);
                                  });
                                }
                              },
                              child: Text(
                                LocaleKeys.upload.tr(),
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (field.value != null)
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 208, 208, 208)),
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    height: 100.0,
                                    width: 100.0,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.file(
                                        field.value!,
                                        alignment: Alignment.center,
                                        fit: BoxFit.fill,
                                      ),
                                    ))
                              else
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius:
                                          BorderRadius.circular(100.0)),
                                  width: 100.0,
                                  height: 100.0,
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 36.0,
                                  ),
                                )
                            ],
                          ))
                    ],
                  ));
            })
      ],
    );
  }
}
