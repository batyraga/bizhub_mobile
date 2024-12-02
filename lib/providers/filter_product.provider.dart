import 'package:bizhub/config/filter/product.dart';
import 'package:bizhub/models/brand.model.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:easy_localization/easy_localization.dart';

class FilterProduct with ChangeNotifier {
  Map<String, List<FilterCategory>> categories = {};
  Map<String, List<FilterBrand>> brands = {};
  Map<String, FilterSeller> sellers = {};
  Map<String, FilterCity> cities = {};

  double? min;
  double? max;
  int? sort;

  String prepareFilterQuery() {
    String q = "";

    if (categories.isNotEmpty) {
      List<String> data = [];

      categories.forEach((key, value) {
        for (var element in value) {
          data.add(element.id);
        }
      });

      data = listToArray(data);

      q = "$q&categories=$data";
    }

    if (brands.isNotEmpty) {
      List<String> data = [];

      brands.forEach((key, value) {
        for (var element in value) {
          data.add(element.id);
        }
      });

      data = listToArray(data);

      q = "$q&brands=$data";
    }

    if (sellers.isNotEmpty) {
      List<String> data = [];

      sellers.forEach((key, value) {
        data.add(value.id);
      });

      data = listToArray(data);

      q = "$q&sellers=$data";
    }

    if (cities.isNotEmpty) {
      List<String> data = [];

      cities.forEach((key, value) {
        data.add(value.id);
      });

      data = listToArray(data);

      q = "$q&cities=$data";
    }
    debugPrint("min=$min, max=$max");
    if (min != null || max != null) {
      List<dynamic> data = [];
      if (min != null) {
        data.add(min);
      } else {
        data.add("\"none\"");
      }

      if (max != null) {
        data.add(max);
      } else {
        data.add("\"none\"");
      }

      q = "$q&price=$data";
    }

    if (sort != null) {
      q = "$q&sort=$sort";
    }

    return q;
  }

  List<String> listToArray(List<String> data) =>
      data.map((e) => "\"$e\"").toList();

  String beautifySortAsString() {
    if (sort != null) {
      if (filterProductSortTypes[sort] != null) {
        return filterProductSortTypes[sort]!.localeKey.tr();
      }
    }
    return "Not set";
  }

  String beautifyCitiesAsString() {
    String str = "";

    cities.forEach((key, value) {
      if (str.isEmpty) {
        str = value.name;
      } else {
        str = "$str, ${value.name}";
      }
    });

    if (str.isEmpty) {
      str = "All";
    }
    return str;
  }

  void addOrRemoveCity(FilterCity city) {
    if (cities.containsKey(city.id)) {
      cities.remove(city.id);
    } else {
      cities[city.id] = city;
    }
    notifyListeners();
  }

  void setMin(double? min_) {
    min = min_;
    notifyListeners();
  }

  void setMax(double? max_) {
    max = max_;
    notifyListeners();
  }

  void setSort(int? a) {
    sort = a;
    notifyListeners();
  }

  List<String> getSellersAsString() {
    return sellers.keys.toList();
  }

  List<String> getCitiesAsString() {
    return cities.keys.toList();
  }

  String beautifyCategoriesAsString() {
    String str = "";

    categories.forEach((key, value) {
      for (var element in value) {
        if (str.isEmpty) {
          str = element.name;
        } else {
          str = "$str, ${element.name}";
        }
      }
    });

    if (str.isEmpty) {
      str = "All";
    }
    return str;
  }

  String beautifyBrandsAsString() {
    String str = "";

    brands.forEach((key, value) {
      for (var element in value) {
        if (str.isEmpty) {
          str = element.name;
        } else {
          str = "$str, ${element.name}";
        }
      }
    });

    if (str.isEmpty) {
      str = "All";
    }
    return str;
  }

  String beautifySellersAsString() {
    String str = "";

    sellers.forEach((key, value) {
      if (str.isEmpty) {
        str = value.name;
      } else {
        str = "$str, ${value.name}";
      }
    });

    if (str.isEmpty) {
      str = "All";
    }
    return str;
  }

  List<String> getCategoryChildrenAsString(String parentId) {
    return categories[parentId] != null
        ? categories[parentId]!.map((e) => e.id).toList()
        : [];
  }

  List<String> getBrandChildrenAsString(String parentId) {
    return brands[parentId] != null
        ? brands[parentId]!.map((e) => e.id).toList()
        : [];
  }

  void clearCities() {
    cities.clear();
    notifyListeners();
  }

  void setSellers(Map<String, FilterSeller> newSellers) {
    sellers = newSellers;
    notifyListeners();
  }

  void setCategories(String parentId, List<FilterCategory> children) {
    categories[parentId] = children;
    notifyListeners();
  }

  void setBrands(String parentId, List<FilterBrand> children) {
    brands[parentId] = children;
    notifyListeners();
  }

  void clearSellers() {
    sellers.clear();
    notifyListeners();
  }

  void clear() {
    categories.clear();
    brands.clear();
    sellers.clear();
    cities.clear();
    notifyListeners();
  }

  void clearCategories() {
    categories.clear();
    notifyListeners();
  }

  void clearBrands() {
    brands.clear();
    notifyListeners();
  }
}
