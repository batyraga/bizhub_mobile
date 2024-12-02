import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/my_seller_wallet.provider.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/auctions/auction_detail.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/package_versions.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/gradients/bg_linear.gradient.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/auctions/main.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/history.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/payment.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/withdraw.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:bizhub/widgets/key_value_widget.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class WalletRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const WalletRoutePage({super.key, required this.parentContext});

  @override
  State<WalletRoutePage> createState() => _WalletRoutePageState();
}

class _WalletRoutePageState extends State<WalletRoutePage> {
  late Future<SellerWallet> futureWallet;
  late String culture;
  // double balance = 0.0;
  // DateTime? expiresAt;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    culture = getLanguageCode(
        EasyLocalization.of(context)!.currentLocale!.languageCode);

    futureWallet = loadSellerWallet();
  }

  Future onRefresh() async {
    setState(() {
      futureWallet = loadSellerWallet();
    });
  }

  Future<SellerWallet> loadSellerWallet() async {
    try {
      final SellerWallet wallet =
          await api.wallet.getMySellerWallet(culture: culture);
      log("my wallet => ${wallet.balance}");
      Future.sync(() => context.read<MySellerWallet>().initState(wallet));
      // setState(() {
      //   balance = wallet.balance;
      //   expiresAt = wallet.package?.expiresAt;
      // });
      return Future.value(wallet);
    } catch (err) {
      // setState(() {
      //   balance = 0.0;
      //   expiresAt = null;
      // });
      log("[loadSellerWallet] - error - $err");
      BizhubFetchErrors.error();

      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(
          title: LocaleKeys.myWallet.tr(),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: FutureBuilder<SellerWallet>(
              future: futureWallet,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final wallet = snapshot.data!;

                  return RefreshIndicator(
                    notificationPredicate: (i) => i.depth == 2,
                    onRefresh: () async {
                      setState(() {
                        futureWallet = loadSellerWallet();
                      });
                    },
                    child: DefaultScrollView(
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: bgLinearGradient,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      context
                                          .watch<MySellerWallet>()
                                          .balance
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 30.0),
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 3),
                                      child: Text(
                                        "TMT",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Color.fromRGBO(
                                                229, 229, 229, 1)),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Consumer<MySellerWallet>(
                                    builder: (context, provider, _) {
                                  final DateTime? expiresAt =
                                      provider.package?.expiresAt;
                                  if (expiresAt == null) {
                                    return Text(
                                      plural(LocaleKeys.walletLeftDuration, 0),
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    );
                                  }
                                  return CountdownTimer(
                                    endTime: expiresAt.millisecondsSinceEpoch,
                                    widgetBuilder: (_, time) {
                                      if (time == null) {
                                        return Text(
                                          LocaleKeys.walletFinished,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ).tr();
                                      }
                                      return Text(
                                        plural(LocaleKeys.walletLeftDuration,
                                            time.days!,
                                            namedArgs: {
                                              'day': time.days.toString(),
                                              'hour': time.hours
                                                  .toString()
                                                  .padLeft(2, "0"),
                                              'second': time.sec
                                                  .toString()
                                                  .padLeft(2, "0"),
                                            }),
                                        // "Left: ${time.days} days ${time.hours.toString().padLeft(2, "0")}:${time.min.toString().padLeft(2, "0")}:${time.sec.toString().padLeft(2, "0")}",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      );
                                    },
                                  );
                                }),
                              ]),
                        ),
                        Consumer<MySellerWallet>(
                            builder: (context, provider, _) {
                          if (provider.package != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  KeyValueWidget(
                                    title: LocaleKeys.walletPackageVersion.tr(),
                                    value: provider.package!.name,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  KeyValueWidget(
                                    title:
                                        LocaleKeys.walletMaximumProducts.tr(),
                                    value: provider.package!.maxProducts
                                        .toString(),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  KeyValueWidget(
                                    title: LocaleKeys.price.tr(),
                                    value:
                                        "${provider.package!.price.toInt()} TMT",
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                        Column(
                          children: [
                            WalletButton(
                              icon: Icons.payment_outlined,
                              title: LocaleKeys.walletPay.tr(),
                              onTap: (context
                                              .watch<MySellerWallet>()
                                              .package
                                              ?.expiresAt
                                              .difference(DateTime.now())
                                              .inDays ??
                                          5) <=
                                      3
                                  ? () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              ctx: context,
                                              type: PageTransitionType.fade,
                                              child: PaymentRoutePage(
                                                  action: "pay",
                                                  type: wallet.package!.type,
                                                  parentContext: context)));
                                    }
                                  : null,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            WalletButton(
                              icon: Icons.payment_outlined,
                              title: LocaleKeys.walletPackageVersions.tr(),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        ctx: context,
                                        type: PageTransitionType.fade,
                                        child: SellerPackageVersionsRoutePage(
                                            activeType: wallet.package?.type,
                                            parentContext: context)));
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            WalletButton(
                              icon: Icons.attractions_outlined,
                              title: LocaleKeys.walletAuctions.tr(),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        ctx: context,
                                        type: PageTransitionType.fade,
                                        child: AuctionsRoutePage(
                                            parentContext: context)));
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            WalletButton(
                              icon: Icons.output_outlined,
                              title: LocaleKeys.walletWithdraw.tr(),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        ctx: context,
                                        type: PageTransitionType.fade,
                                        child: WithdrawRoutePage(
                                            parentContext: context)));
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            WalletButton(
                              icon: Icons.history_outlined,
                              title: LocaleKeys.walletHistory.tr(),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        ctx: context,
                                        type: PageTransitionType.fade,
                                        child: HistoryRoutePage(
                                            parentContext: context)));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Consumer<MySellerWallet>(
                          builder: (context, provider, _) {
                            return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final auction = provider.inAuction[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              ctx: context,
                                              type: PageTransitionType.fade,
                                              child: AuctionDetailRoutePage(
                                                  auctionId: auction.auctionId,
                                                  parentContext: context)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            251, 251, 255, 1),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.warning_rounded,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 6.0,
                                              ),
                                              const Text(
                                                LocaleKeys.moneyInAuction,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Nunito"),
                                              ).tr()
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                            "${auction.amount} TMT",
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Nunito"),
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Text(
                                            auction.name,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Nunito"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 15.0,
                                  );
                                },
                                itemCount: provider.inAuction.length);
                          },
                        ),
                      ]),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text("wallet error");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }
}

class WalletButton extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final IconData icon;
  final Color? backgroundColor;
  final Color? color;
  const WalletButton(
      {super.key,
      this.onTap,
      required this.title,
      required this.icon,
      this.backgroundColor,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: backgroundColor ??
                        Color.fromRGBO(104, 104, 149, onTap != null ? 1 : 0.25),
                    // color: const Color.fromRGBO(104, 104, 149, 0.25),
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10.0),
                color: backgroundColor ??
                    Color.fromRGBO(251, 251, 255, onTap != null ? 1 : 0.25)),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color ??
                      Color.fromRGBO(0, 0, 0, onTap != null ? 1 : 0.25),
                  size: 20.0,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: color ??
                        Color.fromRGBO(0, 0, 0, onTap != null ? 1 : 0.25),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
