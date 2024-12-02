import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/providers/my_seller_wallet.provider.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/models/auction.model.dart';

class BidToAuction extends StatefulWidget {
  final String auctionId;
  final double minimalBid;
  const BidToAuction({
    super.key,
    required this.minimalBid,
    required this.auctionId,
  });

  @override
  State<BidToAuction> createState() => _BidToAuctionState();
}

class _BidToAuctionState extends State<BidToAuction> {
  final TextEditingController _amountController = TextEditingController();
  Future<void> bid() async {
    log("hiii.");
    try {
      final int sum = int.parse(_amountController.value.text.trim());

      if (sum <= 0) {
        log("[bidToAuction] - error - sum mustn't be <= 0");
        return;
      }

      if (widget.minimalBid > sum) {
        log("[bidToAuction] - error - sum must be sum >= minimalBid");
        return;
      }
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);

      final AuctionBidResult result = await api.auctions.bid(
        sum: sum,
        auctionId: widget.auctionId,
        culture: culture,
      );

      Future.sync(() {
        context.read<MySellerWallet>().setBalance(result.balance);
        context.read<MySellerWallet>().addInAuction(result.inAuction);
        Navigator.pop(context, true);
      });

      throw Exception("failed bid to auction");
    } catch (err) {
      log("[bidToAuction] - error - $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    // final double balance = context.watch<MySellerWallet>().balance;

    return Padding(
        padding: EdgeInsets.only(
          top: 20.0,
          bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom,
          right: 20.0,
          left: 20.0,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${LocaleKeys.walletYourBid.tr()}:",
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      "(minimal ${widget.minimalBid.toInt()} TMT)",
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.grey),
                    )
                  ],
                ),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        suffixText: "TMT",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(7.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(7.0))),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            SecondaryButton(onPressed: bid, child: LocaleKeys.walletBid.tr())
          ],
        ));
  }
}
