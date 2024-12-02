import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/screens/user_profile/child_screens/wallet/auctions/auction_detail.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bizhub/models/auction.model.dart';

class AuctionsRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const AuctionsRoutePage({super.key, required this.parentContext});

  @override
  State<AuctionsRoutePage> createState() => _AuctionsRoutePageState();
}

class _AuctionsRoutePageState extends State<AuctionsRoutePage> {
  final PagingController<int, Auction> pagingController =
      PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadAuctions(pageKey, culture);
    });
  }

  Future<void> loadAuctions(int page, String culture) async {
    try {
      final result = await api.auctions.getAll(
        culture: culture,
        page: page,
        limit: _pageSize,
      );
      final bool isLastPage = result.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(result);
      } else {
        pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      log("[loadAuctions] - error - $err");
      pagingController.error = err;
      BizhubFetchErrors.error();
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.walletAuctions.tr(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: PagedListView<int, Auction>.separated(
            padding: const EdgeInsets.all(15.0),
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15.0,
              );
            },
            pagingController: pagingController,
            builderDelegate:
                PagedChildBuilderDelegate(itemBuilder: (context, item, index) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            ctx: context,
                            type: PageTransitionType.fade,
                            child: AuctionDetailRoutePage(
                                auctionId: item.id, parentContext: context)));
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: (MediaQuery.of(context).size.width / 5) * 2,
                        padding: const EdgeInsets.only(
                            left: 15.0, bottom: 15.0, top: 15.0, right: 100.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage("$cdnUrl${item.image}"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  spreadRadius: 0,
                                  offset: Offset(0, 2.5))
                            ]),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.heading,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 19.0),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CountdownTimer(
                                      endTime: item
                                          .finishedAt.millisecondsSinceEpoch,
                                      widgetBuilder: (context, time) {
                                        if (time == null) {
                                          return Text(
                                            LocaleKeys.walletFinished.tr(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0),
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
                                                'hour': time.hours
                                                    .toString()
                                                    .padLeft(2, "0"),
                                                'minute': time.min
                                                    .toString()
                                                    .padLeft(2, "0"),
                                                'second': time.sec
                                                    .toString()
                                                    .padLeft(2, "0")
                                              }),
                                          // "${time.days.toString().padLeft(2, "0")} days ${time.hours.toString().padLeft(2, "0")}:${time.min.toString().padLeft(2, "0")}:${time.sec.toString().padLeft(2, "0")}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0),
                                        );
                                      })
                                ],
                              )
                            ]),
                      ),
                      if (item.isFinished)
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:
                                      const Color.fromRGBO(255, 255, 255, 0.9)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                      child: const Center(
                                          child: Icon(
                                        Icons.check_outlined,
                                        size: 40.0,
                                        color: Colors.white,
                                      )),
                                    ),
                                    const SizedBox(
                                      width: 25.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          LocaleKeys.walletFinished,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22.0),
                                        ).tr(),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "${item.finishedAt.day.toString().padLeft(2, "0")}.${item.finishedAt.month.toString().padLeft(2, "0")}.${item.finishedAt.year.toString().padLeft(2, "0")} ${item.finishedAt.hour.toString().padLeft(2, "0")}:${item.finishedAt.minute.toString().padLeft(2, "0")}",
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Color.fromRGBO(
                                                  85, 85, 85, 1)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))
                    ],
                  ),
                ),
              );
            })),
      ),
    );
  }
}


///
///Column(
      //   children: [
      //     InkWell(
      //       onTap: () {
      //         Navigator.push(
      //             context,
      //             PageTransition(
      //                 ctx: context,
      //                 type: PageTransitionType.fade,
      //                 child: Auction1RoutePage(parentContext: context)));
      //       },
      //       child: Container(
      //         height: 165,
      //         padding: const EdgeInsets.only(
      //             left: 15.0, bottom: 15.0, top: 15.0, right: 100.0),
      //         decoration: BoxDecoration(
      //             image: const DecorationImage(
      //                 image: AssetImage("assets/images/auction-1.png"),
      //                 fit: BoxFit.contain),
      //             borderRadius: BorderRadius.circular(10.0),
      //             color: Colors.red,
      //             boxShadow: const [
      //               BoxShadow(
      //                   blurRadius: 10,
      //                   color: Color.fromRGBO(0, 0, 0, 0.15),
      //                   spreadRadius: 0,
      //                   offset: Offset(0, 2.5))
      //             ]),
      //         child: Column(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               const Text(
      //                 "Main-de reklam banner 14.05-21.05 senesi aralykda",
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                     color: Colors.white,
      //                     fontSize: 19.0),
      //               ),
      //               Row(
      //                 children: const [
      //                   Icon(
      //                     Icons.watch_later_outlined,
      //                     color: Colors.white,
      //                   ),
      //                   SizedBox(
      //                     width: 5,
      //                   ),
      //                   Text(
      //                     "4 days 13:36:22",
      //                     style: TextStyle(color: Colors.white, fontSize: 14.0),
      //                   )
      //                 ],
      //               )
      //             ]),
      //       ),
      //     ),
      //     const SizedBox(
      //       height: 15.0,
      //     ),
      //     Container(
      //       height: 165,
      //       padding: const EdgeInsets.only(
      //           left: 15.0, bottom: 15.0, top: 15.0, right: 100.0),
      //       decoration: BoxDecoration(
      //           image: const DecorationImage(
      //               image: AssetImage("assets/images/auction-2.png"),
      //               fit: BoxFit.contain),
      //           borderRadius: BorderRadius.circular(10.0),
      //           color: Colors.red,
      //           boxShadow: const [
      //             BoxShadow(
      //                 blurRadius: 10,
      //                 color: Color.fromRGBO(0, 0, 0, 0.15),
      //                 spreadRadius: 0,
      //                 offset: Offset(0, 2.5))
      //           ]),
      //       child: Column(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             const Text(
      //               "Main-de reklam banner 14.05-21.05 senesi aralykda",
      //               style: TextStyle(
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.white,
      //                   fontSize: 19.0),
      //             ),
      //             Row(
      //               children: const [
      //                 Icon(
      //                   Icons.watch_later_outlined,
      //                   color: Colors.white,
      //                 ),
      //                 SizedBox(
      //                   width: 5,
      //                 ),
      //                 Text(
      //                   "4 days 13:36:22",
      //                   style: TextStyle(color: Colors.white, fontSize: 14.0),
      //                 )
      //               ],
      //             )
      //           ]),
      //     ),
      //     const SizedBox(
      //       height: 15.0,
      //     ),
      //     Stack(
      //       children: [
      //         Container(
      //           height: 165,
      //           padding: const EdgeInsets.only(
      //               left: 15.0, bottom: 15.0, top: 15.0, right: 100.0),
      //           decoration: BoxDecoration(
      //               image: const DecorationImage(
      //                   image: AssetImage("assets/images/auction-1.png"),
      //                   fit: BoxFit.contain),
      //               borderRadius: BorderRadius.circular(10.0),
      //               color: Colors.red,
      //               boxShadow: const [
      //                 BoxShadow(
      //                     blurRadius: 10,
      //                     color: Color.fromRGBO(0, 0, 0, 0.15),
      //                     spreadRadius: 0,
      //                     offset: Offset(0, 2.5))
      //               ]),
      //           child: Column(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 const Text(
      //                   "Main-de reklam banner 14.05-21.05 senesi aralykda",
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.white,
      //                       fontSize: 19.0),
      //                 ),
      //                 Row(
      //                   children: const [
      //                     Icon(
      //                       Icons.watch_later_outlined,
      //                       color: Colors.white,
      //                     ),
      //                     SizedBox(
      //                       width: 5,
      //                     ),
      //                     Text(
      //                       "4 days 13:36:22",
      //                       style:
      //                           TextStyle(color: Colors.white, fontSize: 14.0),
      //                     )
      //                   ],
      //                 )
      //               ]),
      //         ),
      //         Positioned(
      //             top: 0,
      //             left: 0,
      //             right: 0,
      //             bottom: 0,
      //             child: Container(
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(10.0),
      //                   color: const Color.fromRGBO(255, 255, 255, 0.9)),
      //               child: Center(
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Container(
      //                       width: 70,
      //                       height: 70,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100.0),
      //                           color: Theme.of(context).colorScheme.primary),
      //                       child: const Center(
      //                           child: Icon(
      //                         Icons.check_outlined,
      //                         size: 40.0,
      //                         color: Colors.white,
      //                       )),
      //                     ),
      //                     const SizedBox(
      //                       width: 25.0,
      //                     ),
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: const [
      //                         Text(
      //                           "Finished!",
      //                           style: TextStyle(
      //                               fontWeight: FontWeight.bold,
      //                               fontSize: 22.0),
      //                         ),
      //                         SizedBox(
      //                           height: 8,
      //                         ),
      //                         Text(
      //                           "14.05.2022 00:00",
      //                           style: TextStyle(
      //                               fontSize: 14.0,
      //                               color: Color.fromRGBO(85, 85, 85, 1)),
      //                         )
      //                       ],
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ))
      //       ],
      //     )
      //   ],
      // )
///
///
///