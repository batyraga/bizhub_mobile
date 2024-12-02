import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SellerNameTab extends StatefulWidget {
  const SellerNameTab({super.key});

  @override
  State<SellerNameTab> createState() => _SellerNameTabState();
}

class _SellerNameTabState extends State<SellerNameTab> {
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
                    color: const Color.fromRGBO(110, 90, 209, 1)),
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
                                  LocaleKeys.becomeSellerJeffBezosName.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  LocaleKeys.becomeSellerJeffBezosRole.tr(),
                                  style: const TextStyle(
                                      color: Color.fromRGBO(205, 205, 205, 1),
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
                          LocaleKeys.becomeSellerJeffBezosText.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ]),
        )),
        Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${LocaleKeys.enterBrandOrShopName.tr()}:",
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ReactiveTextField(
                  // onChanged: (value) {
                  //   widget.controller.setName(value.trim());
                  // },
                  formControlName: "name",
                  // controller: _nameController,
                )
              ],
            ))
      ],
    );
  }
}
