import 'dart:convert';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/models/user.model.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  bool isAuthenticated = false;
  bool isSeller = false;
  String? accessToken;
  String? refreshToken;
  User? currentUser;

  Auth initState() {
    Future<void> onLogout([List<dynamic>? data]) async {
      logout();
      globalEvents.emit("loginModal");
    }

    globalEvents.on("logout", onLogout);

    Future<void> aa() async {
      final auth_ = storage.read("auth");
      final bool auth = auth_ == "true" ? true : false;
      if (auth) {
        final refreshToken_ = storage.read("refresh_token");
        final accessToken_ = storage.read("access_token");
        final a = storage.read("user");
        if (a != null) {
          try {
            currentUser = User.fromJson(jsonDecode(a));
            refreshToken = refreshToken_;
            accessToken = accessToken_;
            isSeller = currentUser!.sellerId != null;
            isAuthenticated = auth;
            notifyListeners();
          } catch (err) {
            debugPrint("auth initState [err] => $err");
          }
        }
      }
    }

    aa();
    return this;
  }

  void setTokens(String a, String r) {
    accessToken = a;
    refreshToken = r;

    storage.write("access_token", a);
    storage.write("refresh_token", a);

    // api.checkAuth();

    notifyListeners();
  }

  changeAccessToken(String t) {
    accessToken = t;
    notifyListeners();
  }

  Future<bool> signUp(User user, String a, String r) async {
    currentUser = user;
    isSeller = currentUser!.sellerId != null;
    isAuthenticated = true;

    final emptyArrayAsString = jsonEncode([]);

    storage.write("user", jsonEncode(currentUser));
    storage.write("access_token", a);
    storage.write("refresh_token", r);
    storage.write("f_posts", emptyArrayAsString);
    storage.write("f_products", emptyArrayAsString);
    storage.write("f_sellers", emptyArrayAsString);
    storage.write("auth", "true");

    return true;
  }

  Future<bool> login(String phone, String password) async {
    try {
      final Map<String, dynamic> data = await api.auth.login(phone, password);
      debugPrint(data.toString());
      currentUser = User.fromJson(data["user"]);

      // ---
      isSeller = currentUser!.sellerId != null;
      isAuthenticated = true;
      storage.write("user", jsonEncode(currentUser));
      storage.write("access_token", data["access_token"]);
      storage.write("refresh_token", data["refresh_token"]);
      storage.write("f_posts", jsonEncode(data["favorites"]["posts"]));
      storage.write("f_products", jsonEncode(data["favorites"]["products"]));
      storage.write("f_sellers", jsonEncode(data["favorites"]["sellers"]));
      storage.write("auth", "true");
      // api.checkAuth();
      // notifyListeners();
      return true;
    } catch (err) {
      debugPrint("login err => $err");
      return false;
    }
  }

  void changeStatusAsSeller(String sellerId_) {
    if (currentUser == null) {
      return;
    }

    currentUser!.setSellerId(sellerId_);
    storage.write("user", jsonEncode(currentUser));

    isSeller = true;
    notifyListeners();
  }

  void changeCurrentUserName(String newName) {
    if (currentUser == null) {
      return;
    }

    currentUser!.setName(newName);
    storage.write("user", jsonEncode(currentUser));

    notifyListeners();
  }

  void changeCurrentUserLogo(String logo) {
    if (currentUser == null) {
      return;
    }

    currentUser!.setLogo(logo);
    storage.write("user", jsonEncode(currentUser));

    notifyListeners();
  }

  void logout() {
    isAuthenticated = false;
    isSeller = false;
    currentUser = null;
    accessToken = null;
    refreshToken = null;

    storage.remove("auth");
    storage.remove("user");
    storage.remove(
      "access_token",
    );
    storage.remove(
      "refresh_token",
    );
    storage.remove("f_posts");
    storage.remove("f_products");
    storage.remove("f_sellers");
    storage.remove("f_products_data-[tm]");
    storage.remove("f_products_data-[en]");
    storage.remove("f_products_data-[ru]");
    storage.remove("f_products_data-[tr]");
    storage.remove("f_sellers_data-[tm]");
    storage.remove("f_sellers_data-[en]");
    storage.remove("f_sellers_data-[ru]");
    storage.remove("f_sellers_data-[tr]");

    // api.checkAuth();

    notifyListeners();
    return;
  }
}
