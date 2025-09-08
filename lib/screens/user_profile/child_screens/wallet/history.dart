import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/my_seller_wallet.provider.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HistoryRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const HistoryRoutePage({super.key, required this.parentContext});

  @override
  State<HistoryRoutePage> createState() => _HistoryRoutePageState();
}

class _HistoryRoutePageState extends State<HistoryRoutePage> {
  final PagingController<int, SellerWalletHistoryTransaction> pagingController =
      PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();

    pagingController.addPageRequestListener((pageKey) async {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      await loadSellerWalletHistory(pageKey, culture);
    });
  }

  Future<void> loadSellerWalletHistory(int page, String culture) async {
    try {
      final result = await api.wallet.getMySellerWalletHistory(
          page: page, limit: _pageSize, culture: culture);

      final bool isLastPage = result.length < _pageSize;

      if (isLastPage) {
        pagingController.appendLastPage(result);
      } else {
        pagingController.appendPage(result, page + 1);
      }
    } catch (err) {
      log("[loadSellerWalletHistory] - error - $err");
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
      appBar: DefaultAppBar(title: LocaleKeys.walletHistory.tr()),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: PagedListView<int, SellerWalletHistoryTransaction>.separated(
            pagingController: pagingController,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15.0,
              );
            },
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            builderDelegate:
                PagedChildBuilderDelegate<SellerWalletHistoryTransaction>(
                    itemBuilder: (context, item, index) {
              return HistoryCard(item: item);
            })),
      ),
    );
  }
}

class HistoryCardMethod {
  final String name;
  final Color? color;
  const HistoryCardMethod(
      {required this.name, this.color = const Color.fromRGBO(254, 190, 19, 1)});
}

final _historyCardMethods = <String, HistoryCardMethod>{
  "withdraw": HistoryCardMethod(
    name: LocaleKeys.walletWithdraw.tr(),
  ),
  "deposit": HistoryCardMethod(
      name: LocaleKeys.walletDeposit.tr(),
      color: const Color.fromRGBO(78, 198, 63, 1)),
  "payment": HistoryCardMethod(
      name: LocaleKeys.walletPayment.tr(),
      color: const Color.fromRGBO(78, 78, 223, 1)),
};

class HistoryCard extends StatefulWidget {
  final SellerWalletHistoryTransaction item;
  const HistoryCard({super.key, required this.item});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  bool loading = false;
  late String status = widget.item.status;

  Future<void> cancelTransaction() async {
    setState(() {
      loading = true;
    });
    try {
      final double newBalance =
          await api.wallet.cancelWithdraw(id: widget.item.id);

      Future.sync(() {
        setState(() {
          status = "cancelled";
        });
        context.read<MySellerWallet>().setBalance(newBalance);

        const snackBar = SnackBar(content: Text("Canceled withdraw action"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } catch (err) {
      log("[cancelTransaction] - error - $err");
      final snackBar = SnackBar(content: Text("$err"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          bottom: (status == "waiting" &&
                  widget.item.intent == "withdraw" &&
                  widget.item.code != null)
              ? 5.0
              : 15.0,
          top: 15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromARGB(255, 247, 247, 255)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(
                  "${widget.item.createdAt.day.toString().padLeft(2, "0")}/${widget.item.createdAt.month.toString().padLeft(2, "0")}/${widget.item.createdAt.year.toString().padLeft(2, "0")}y  ${widget.item.createdAt.hour.toString().padLeft(2, "0")}:${widget.item.createdAt.minute.toString().padLeft(2, "0")}:${widget.item.createdAt.second.toString().padLeft(2, "0")}",
                  style: const TextStyle(
                      color: Color.fromRGBO(103, 103, 103, 1), fontSize: 14.0),
                ),
              ]),
              Text(
                _historyCardMethods[widget.item.intent]!.name,
                style: TextStyle(
                    color: _historyCardMethods[widget.item.intent]!.color,
                    fontSize: 14.0),
              )
            ],
          ),
          const SizedBox(
            height: 13.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.item.amount.toInt()} TMT",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              if (widget.item.intent != "payment" &&
                  widget.item.intent != "deposit")
                Text(
                  "${status == "cancelled" ? "Cancelled" : ""}${status == "received" ? "Received" : ""}${status == "waiting" ? "Not received, waiting.." : ""}",
                  style: const TextStyle(
                    color: Color.fromRGBO(180, 180, 222, 1),
                    fontSize: 14.0,
                  ),
                )
            ],
          ),
          if (widget.item.note != null ||
              (widget.item.code != null && status != "waiting"))
            const SizedBox(
              height: 10.0,
            ),
          if (widget.item.code != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${LocaleKeys.walletCode.tr()}:",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      widget.item.code!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                if (status == "waiting")
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          foregroundColor: Colors.red,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent),
                      onPressed: loading ? null : cancelTransaction,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          child: loading
                              ? const SizedBox(
                                  height: 18.0,
                                  width: 18.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  ))
                              : const Text(LocaleKeys.walletCancel).tr()))
              ],
            ),
          if (widget.item.note != null)
            Text(
              widget.item.note!,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            )
        ],
      ),
    );
  }
}
