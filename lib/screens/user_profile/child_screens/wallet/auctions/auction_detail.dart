import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/auctions/bid_to_auction.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:bizhub/models/auction.model.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:provider/provider.dart';

class AuctionDetailRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final String auctionId;
  const AuctionDetailRoutePage(
      {super.key, required this.auctionId, required this.parentContext});

  @override
  State<AuctionDetailRoutePage> createState() => _AuctionDetailRoutePageState();
}

class _AuctionDetailRoutePageState extends State<AuctionDetailRoutePage> {
  late Future<AuctionDetail> futureAuctionDetail;
  late String culture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    culture = getLanguageCode(
        EasyLocalization.of(context)!.currentLocale!.languageCode);
    futureAuctionDetail = loadAuctionDetail();
  }

  Future<AuctionDetail> loadAuctionDetail() async {
    try {
      final result = await api.auctions
          .getAuctionDetail(culture: culture, auctionId: widget.auctionId);

      return result;
    } catch (err) {
      log("[loadAuctionDetail] - error - $err");
      BizhubFetchErrors.error();
      return Future.error(err);
    }
  }

  Future onRefresh() async {
    setState(() {
      futureAuctionDetail = loadAuctionDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar(),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: FutureBuilder<AuctionDetail>(
              future: futureAuctionDetail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final auction = snapshot.data!;
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(
                                  height:
                                      (MediaQuery.of(context).size.width / 5) *
                                          2.85,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: "$cdnUrl${auction.image}",
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Text(
                                auction.heading,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              const SizedBox(height: 15.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.history_outlined,
                                    color: Color.fromARGB(255, 114, 114, 114),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  CountdownTimer(
                                    endTime: auction
                                        .finishedAt.millisecondsSinceEpoch,
                                    widgetBuilder: (context, time) {
                                      if (time == null) {
                                        return const Text(
                                          "Finished",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 114, 114, 114)),
                                        );
                                      }
                                      return Text(
                                        plural(
                                            LocaleKeys
                                                .walletAuctionDurationCountDown,
                                            time.days!,
                                            namedArgs: {
                                              'day': time.days
                                                  .toString()
                                                  .padLeft(2, "0"),
                                              'month': time.min
                                                  .toString()
                                                  .padLeft(2, "0"),
                                              'hour': time.hours
                                                  .toString()
                                                  .padLeft(2, "0"),
                                              'second': time.sec
                                                  .toString()
                                                  .padLeft(2, "0"),
                                            }),
                                        // "${time.days.toString().padLeft(2, "0")} days ${time.hours.toString().padLeft(2, "0")}:${time.min.toString().padLeft(2, "0")}:${time.sec.toString().padLeft(2, "0")}",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 114, 114, 114)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15.0),
                              Text(
                                auction.description,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.walletParticipants.tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    auction.participants.toString(),
                                    style: const TextStyle(fontSize: 16.0),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Row(
                                children: [
                                  Text(
                                    LocaleKeys.walletMinimalBid.tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${auction.minimalBid.toInt()} TMT",
                                    style: const TextStyle(fontSize: 16.0),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.wb_incandescent_rounded),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    LocaleKeys.walletWinners.tr(),
                                    style: const TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              // aaaaa
                            ]),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: auction.winners.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final winner = auction.winners[index];
                          return Container(
                            color:
                                context.watch<Auth>().currentUser?.sellerId ==
                                        winner.sellerId
                                    ? const Color.fromRGBO(251, 251, 255, 1)
                                    : Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            (index + 1).toString(),
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            child: CachedNetworkImage(
                                                width: 50,
                                                height: 50,
                                                imageUrl:
                                                    "$cdnUrl${winner.seller.logo}"),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                winner.seller.name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17.0),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                winner.seller.city.name,
                                                style: const TextStyle(
                                                    fontSize: 12.5,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(
                                        "${winner.lastBid.toInt()} TMT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 2.5,
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 35.0,
                            ),
                            if (!auction.isFinished &&
                                !auction.winners.any(
                                  (element) =>
                                      element.sellerId ==
                                      (context
                                          .watch<Auth>()
                                          .currentUser
                                          ?.sellerId),
                                ))
                              SecondaryButton(
                                  onPressed: () async {
                                    final bool? bidResult =
                                        await showModalBottomSheet<bool?>(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BidToAuction(
                                                auctionId: auction.id,
                                                minimalBid: auction.minimalBid,
                                              );
                                            },
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20.0))));
                                    if (bidResult == true) {
                                      setState(() {
                                        futureAuctionDetail =
                                            loadAuctionDetail();
                                      });
                                    }
                                  },
                                  child: LocaleKeys.walletBid.tr())
                          ],
                        ),
                      )
                    ],
                  ));
                } else if (snapshot.hasError) {
                  return const Text("auction detail error");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }
}
