import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/shimmers/seller_categories.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SellerCategories extends StatefulWidget {
  final String sellerId;
  const SellerCategories({
    super.key,
    required this.sellerId,
  });

  @override
  State<SellerCategories> createState() => _SellerCategoriesState();
}

class _SellerCategoriesState extends State<SellerCategories> {
  late Future<List<Category>> futureCategories;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureCategories = loadSellerCategories();
  }

  Future<List<Category>> loadSellerCategories() async {
    try {
      final culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      return await api.categories.getSellerCategories(
        culture: culture,
        id: widget.sellerId,
      );
    } catch (err) {
      BizhubFetchErrors.error();

      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<Category> categories = snapshot.data!;
            if (categories.isEmpty) {
              return const SizedBox();
            }
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: 10.0, top: 4.0, left: 15.0, right: 15.0),
              child: SizedBox(
                height: 32.0,
                child: ListView.separated(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final Category category = categories[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(110, 90, 209, 0.15),
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Text(category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              color: Color(0xff6E5AD1),
                            )),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 15.0,
                      );
                    },
                    itemCount: categories.length),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text("error");
          }
          return const Padding(
              padding: EdgeInsets.only(
                  bottom: 10.0, top: 4.0, left: 15.0, right: 15.0),
              child: SizedBox(height: 40, child: ShimmerSellerCategories()));
        });
  }
}
