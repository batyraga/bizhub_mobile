import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/providers/my_seller_wallet.provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/key_value_widget.dart';

class WithdrawRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const WithdrawRoutePage({super.key, required this.parentContext});

  @override
  State<WithdrawRoutePage> createState() => _WithdrawRoutePageState();
}

class _WithdrawRoutePageState extends State<WithdrawRoutePage> {
  bool canWithdraw = false;
  final TextEditingController _amountController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {
        canWithdraw = _amountController.text.isNotEmpty;
      });
    });
  }

  Future<void> withdraw() async {
    try {
      int sum = int.parse(_amountController.value.text.trim().toString());

      if (sum <= 0) {
        return;
      }

      setState(() {
        loading = true;
      });

      final double newBalance = await api.wallet.withdraw(sum: sum);
      log("[withdraw] - newBalance - $newBalance");

      Future.sync(() {
        context.read<MySellerWallet>().setBalance(newBalance);

        // showCustomAlertDialog(
        //   context,
        //   description: "Success withdraw action",
        // );
        Navigator.pop(
          context,
        );
      });
      return;
    } catch (err) {
      log("[withdraw] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.watch<MySellerWallet>().balance;
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.walletWithdraw.tr()),
      body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                KeyValueWidget(
                    title: LocaleKeys.walletBalance.tr(),
                    value: '$balance TMT'),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text(
                          LocaleKeys.walletSum,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        ).tr(),
                        const SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          "(max $balance TMT)",
                          style: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 17.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 120,
                      height: 40,
                      child: TextField(
                        enabled: !loading,
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: "TMT",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(7.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(7.0))),
                      ),
                    )
                  ],
                )
              ]),
              SecondaryButton(
                  onPressed: canWithdraw ? withdraw : null,
                  child: LocaleKeys.walletWithdraw.tr())
            ],
          )),
    );
  }
}
