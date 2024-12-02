import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/hex_color.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/my_seller_wallet.provider.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/payment.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SellerPackageVersionsRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final String? activeType;
  const SellerPackageVersionsRoutePage(
      {super.key, required this.parentContext, required this.activeType});

  @override
  State<SellerPackageVersionsRoutePage> createState() =>
      _SellerPackageVersionsRoutePageState();
}

class _SellerPackageVersionsRoutePageState
    extends State<SellerPackageVersionsRoutePage> {
  late Future<List<SellerPackage>> futurePackages;
  late String culture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    culture = getLanguageCode(
        EasyLocalization.of(context)!.currentLocale!.languageCode);

    futurePackages = loadSellerPackages();
  }

  Future<List<SellerPackage>> loadSellerPackages() async {
    try {
      final List<SellerPackage> packages =
          await api.packages.getAll(culture: culture);
      return Future.value(packages);
    } catch (err) {
      log("[loadSellerPackages] - error - $err");
      BizhubFetchErrors.error();
      return Future.error(err);
    }
  }

  Future onRefresh() async {
    setState(() {
      futurePackages = loadSellerPackages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.walletPackageVersions.tr(),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<List<SellerPackage>>(
            future: futurePackages,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                final List<SellerPackage> packages = snapshot.data!;

                return ListView.separated(
                    separatorBuilder: (ctx, index) {
                      return const SizedBox(
                        height: 20.0,
                      );
                    },
                    itemCount: packages.length,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    itemBuilder: (context, index) {
                      final package = packages[index];

                      final textColor =
                          HexColor.fromHex("#${package.textColor}");
                      final bgColor = HexColor.fromHex("#${package.color}");

                      return GestureDetector(
                        onTap: widget.activeType != package.type &&
                                ((context
                                            .watch<MySellerWallet>()
                                            .package
                                            ?.expiresAt
                                            .difference(DateTime.now())
                                            .inDays ??
                                        5) <=
                                    3)
                            ? () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        ctx: context,
                                        type: PageTransitionType.fade,
                                        child: PaymentRoutePage(
                                            action: "changed",
                                            type: package.type,
                                            parentContext: context)));
                              }
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 8.0,
                                    color: Color.fromRGBO(0, 0, 0, 0.15))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14.0, horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      package.name,
                                      style: TextStyle(
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                        fontSize: 19.0,
                                      ),
                                    ),
                                    if (context
                                            .watch<MySellerWallet>()
                                            .package
                                            ?.type ==
                                        package.type)
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                color: textColor),
                                            child: Center(
                                                child: Icon(
                                              Icons.check_outlined,
                                              size: 13.0,
                                              color: bgColor,
                                            )),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            LocaleKeys.walletSelected.tr(),
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize: 14.0),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: package.price
                                                .toInt()
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 30.0,
                                                fontFamily: "Nunito",
                                                fontWeight: FontWeight.w700),
                                            children: const [
                                          TextSpan(
                                              text: " TMT / month",
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                  color: Color.fromRGBO(
                                                      119, 119, 119, 1)))
                                        ])),
                                    const SizedBox(height: 15.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          LocaleKeys.walletMaximumProducts,
                                          style: TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w700,
                                              color: Color.fromRGBO(
                                                  85, 85, 85, 1)),
                                        ).tr(),
                                        Text(
                                          package.maxProducts.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Nunito",
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromRGBO(
                                                  85, 85, 85, 1)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              } else if (snapshot.hasError) {
                return const Text("packages error");
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
