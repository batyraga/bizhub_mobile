import 'dart:convert';
import 'dart:developer';

import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/storage.provider.dart';
import 'package:flutter/material.dart';

class Favorites with ChangeNotifier {
  List<String> favoritePosts = [];
  List<String> favoriteProducts = [];
  List<String> favoriteSellers = [];

  // Map<String, Product> favoriteProductsDatas = {};
  // Map<String, Seller> favoriteSellersDatas = {};

  Favorites initState() {
    final String? posts = storage.read("f_posts");
    if (posts != null) {
      favoritePosts = List<String>.from(jsonDecode(posts));
      log("[]posts=> $favoritePosts");
    }

    final String? products = storage.read("f_products");
    if (products != null) {
      favoriteProducts = List<String>.from(jsonDecode(products));
    }

    final String? sellers = storage.read("f_sellers");
    if (sellers != null) {
      favoriteSellers = List<String>.from(jsonDecode(sellers));
    }

    storage.on(StorageEventType.write, "f_posts", (String posts) {
      try {
        favoritePosts = List<String>.from(jsonDecode(posts));
        notifyListeners();
      } catch (err) {
        favoritePosts = [];
      }
    });
    storage.on(StorageEventType.write, "f_products", (String products) {
      try {
        favoriteProducts = List<String>.from(jsonDecode(products));
        notifyListeners();
      } catch (err) {
        favoriteProducts = [];
      }
    });
    storage.on(StorageEventType.write, "f_sellers", (String sellers) {
      try {
        favoriteSellers = List<String>.from(jsonDecode(sellers));
        notifyListeners();
      } catch (err) {
        favoriteSellers = [];
      }
    });

    storage.on(StorageEventType.remove, "f_posts", () {
      favoritePosts.clear();
      notifyListeners();
    });
    storage.on(StorageEventType.remove, "f_products", () {
      favoriteProducts.clear();
      notifyListeners();
    });
    storage.on(StorageEventType.remove, "f_sellers", () {
      favoriteSellers.clear();
      notifyListeners();
    });
    return this;
  }

  void setFavoriteProducts(List<String> f) {
    favoriteProducts = f;
    notifyListeners();
  }

  void setFavoriteSellers(List<String> f) {
    favoriteSellers = f;
    notifyListeners();
  }

  // void setFavoriteProductsData(Map<String, Product> data) {
  //   favoriteProductsDatas = data;
  //   notifyListeners();
  // }

  // void setFavoriteSellersData(Map<String, Seller> data) {
  //   favoriteSellersDatas = data;
  //   notifyListeners();
  // }

  bool isFavoritePost(String postId) {
    return favoritePosts.contains(postId);
  }

  bool isFavoriteProduct(String productId) {
    return favoriteProducts.contains(productId);
  }

  bool isFavoriteSeller(String sellerId) {
    return favoriteSellers.contains(sellerId);
  }

  void addOrRemoveFromFavoritePosts(String postId) {
    if (isFavoritePost(postId)) {
      favoritePosts =
          favoritePosts.where((element) => element != postId).toList();
    } else {
      favoritePosts.add(postId);
    }
    storage.write("f_posts", jsonEncode(favoritePosts));
    notifyListeners();
  }

  void addOrRemoveFromFavoriteProducts(Product product, String culture) {
    if (isFavoriteProduct(product.id)) {
      favoriteProducts =
          favoriteProducts.where((element) => element != product.id).toList();
      // favoriteProductsDatas.remove(product.id);
    } else {
      favoriteProducts.add(product.id);
      // favoriteProductsDatas[product.id] = product;
    }
    storage.write("f_products", jsonEncode(favoriteProducts));
    // storage.write(
    //     "f_products_data-[$culture]", jsonEncode(favoriteProductsDatas));
    notifyListeners();
  }

  void addOrRemoveFromFavoriteSellers(Seller seller, String culture) {
    if (isFavoriteSeller(seller.id)) {
      favoriteSellers =
          favoriteSellers.where((element) => element != seller.id).toList();
      // favoriteSellersDatas.remove(seller.id);
    } else {
      favoriteSellers.add(seller.id);
      // favoriteSellersDatas[seller.id] = seller;
    }

    storage.write("f_sellers", jsonEncode(favoriteSellers));
    // storage.write(
    //     "f_sellers_data-[$culture]", jsonEncode(favoriteSellersDatas));
    notifyListeners();
  }
}
