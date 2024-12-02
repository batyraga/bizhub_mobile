import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/my_seller_wallet.provider.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/custom_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/key_value_widget.dart';

class PaymentRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final String type;
  final String action;
  const PaymentRoutePage(
      {super.key,
      required this.action,
      required this.type,
      required this.parentContext});

  @override
  State<PaymentRoutePage> createState() => _PaymentRoutePageState();
}

class _PaymentRoutePageState extends State<PaymentRoutePage> {
  late String culture;
  late Future<SellerPackageDetail> futurePackage;
  String title = "Loading..";
  bool loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    culture = getLanguageCode(
        EasyLocalization.of(context)!.currentLocale!.languageCode);

    futurePackage = loadSellerPackageByType();
  }

  Future<SellerPackageDetail> loadSellerPackageByType() async {
    try {
      final package =
          await api.packages.getPackage(culture: culture, type: widget.type);
      setState(() {
        title = "Change package as ${package.name}";
      });
      log("[loadSellerPackageByType] - result - $package");
      return package;
    } catch (err) {
      log("[loadSellerPackageByType] - error - $err");
      BizhubFetchErrors.error();
      return Future.error(err);
    }
  }

  Future<void> pay(SellerPackageDetail package) async {
    final bool status =
        await showConfirmDialog(context, "Do you want pay current package");
    if (!status) {
      return;
    }

    setState(() {
      loading = true;
    });
    try {
      final WalletPayResult result =
          await api.wallet.pay(action: widget.action, type: package.type);

      Future.sync(() async {
        context.read<MySellerWallet>().setBalance(result.balance);
        if (widget.action == "pay") {
          context
              .read<MySellerWallet>()
              .setPackageExpiresAt(result.packageExpiresAt);
        } else {
          context.read<MySellerWallet>().setPackage(SellerWalletPackage(
              maxProducts: package.maxProducts,
              name: package.name,
              price: package.price,
              expiresAt: result.packageExpiresAt,
              type: package.type));
        }
        await showCustomAlertDialog(context,
            description: "Successful pay action");
        Future.sync(() => Navigator.pop(context));
      });
      // aaa
    } catch (err) {
      log("[pay] - error - $err");
    }
    setState(() {
      loading = false;
    });
  }

  Future onRefresh() async {
    setState(() {
      futurePackage = loadSellerPackageByType();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.action == 'pay' ? LocaleKeys.walletPayment.tr() : title,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<SellerPackageDetail>(
            future: futurePackage,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final package = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          KeyValueWidget(
                              title: LocaleKeys.walletPayment.tr(),
                              value: package.name),
                          const SizedBox(
                            height: 20.0,
                          ),
                          KeyValueWidget(
                              title: LocaleKeys.walletMaximumProducts.tr(),
                              value: package.maxProducts != null
                                  ? LocaleKeys.walletUnlimited.tr()
                                  : package.maxProducts!.toInt().toString()),
                          const SizedBox(
                            height: 20.0,
                          ),
                          KeyValueWidget(
                              title: LocaleKeys.price.tr(),
                              value: "${package.price.toInt()} TMT"),
                          const SizedBox(
                            height: 20.0,
                          ),
                          KeyValueWidget(
                              title: LocaleKeys.walletTime.tr(),
                              value: "30 days"),
                          const SizedBox(
                            height: 20.0,
                          ),
                          CountdownTimer(
                              endTime: context
                                      .watch<MySellerWallet>()
                                      .package
                                      ?.expiresAt
                                      .millisecondsSinceEpoch ??
                                  DateTime(
                                    0,
                                  ).millisecondsSinceEpoch,
                              widgetBuilder: (context, time) {
                                if (time == null) {
                                  return const Text(
                                    LocaleKeys.walletFinished,
                                    style: TextStyle(
                                        color: Color.fromRGBO(142, 142, 223, 1),
                                        fontSize: 14),
                                  ).tr();
                                }
                                return Text(
                                  plural(
                                      LocaleKeys
                                          .walletYourCurrentPackageWillEnd,
                                      time.days!,
                                      namedArgs: {
                                        'day': time.days
                                            .toString()
                                            .padLeft(2, "0"),
                                        'hour': time.hours
                                            .toString()
                                            .padLeft(2, "0"),
                                        'minute':
                                            time.min.toString().padLeft(2, "0"),
                                        'second':
                                            time.sec.toString().padLeft(2, "0")
                                      }),
                                  // "Your current package will end in ${time.days.toString().padLeft(2, "0")} days ${time.hours.toString().padLeft(2, "0")}:${time.min.toString().padLeft(2, "0")}:${time.sec.toString().padLeft(2, "0")}. Your new package will start after the end of the current package.",
                                  style: const TextStyle(
                                      color: Color.fromRGBO(142, 142, 223, 1),
                                      fontSize: 14),
                                );
                              }),
                        ],
                      ),
                      SecondaryButton(
                          loading: loading,
                          onPressed: () async {
                            await pay(package);
                          },
                          child: widget.action == "pay"
                              ? LocaleKeys.walletPay.tr()
                              : LocaleKeys.change.tr())
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Expanded(child: Text("package error"));
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
