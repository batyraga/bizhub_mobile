import 'package:bizhub/models/sellers.model.dart';
import 'package:flutter/material.dart';

class MySellerWallet with ChangeNotifier {
  SellerWalletPackage? package;
  double balance = 0.0;
  List<SellerWalletInAuction> inAuction = [];

  void initState(SellerWallet wallet) {
    balance = wallet.balance;
    package = wallet.package;
    inAuction = wallet.inAuction;
    notifyListeners();
  }

  void removeState() {
    balance = 0.0;
    package = null;
    inAuction = [];
    notifyListeners();
  }

  void addInAuction(SellerWalletInAuction auction) {
    inAuction.add(auction);
    notifyListeners();
  }

  void setBalance(double newBalance) {
    balance = newBalance;
    notifyListeners();
  }

  void setPackageExpiresAt(DateTime date) {
    if (package != null) {
      package!.expiresAt = date;
      notifyListeners();
    }
  }

  void setPackage(SellerWalletPackage p) {
    package = p;
    notifyListeners();
  }
}
