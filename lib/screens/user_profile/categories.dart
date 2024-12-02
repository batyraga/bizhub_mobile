import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/shimmers/seller_categories.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SellerProfileCategories extends StatefulWidget {
  const SellerProfileCategories({
    super.key,
  });

  @override
  State<SellerProfileCategories> createState() =>
      _SellerProfileCategoriesState();
}

class _SellerProfileCategoriesState extends State<SellerProfileCategories> {
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
      return await api.auth.mySellerProfileCategories(
        culture: culture,
      );
    } catch (err) {
      BizhubFetchErrors.error();

      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey("refresh seller categories"),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              setState(() {
                futureCategories = loadSellerCategories();
              });
            },
            backgroundColor: Colors.transparent,
            foregroundColor: primaryColor,
            icon: Icons.refresh_outlined,
          ),
        ],
      ),
      child: FutureBuilder<List<Category>>(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final List<Category> categories = snapshot.data!;
              if (categories.isEmpty) {
                return const SizedBox(height: 10.0);
              }
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0, top: 4.0, left: 15.0, right: 15.0),
                child: SizedBox(
                  height: 40.0,
                  child: ListView.separated(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final Category category = categories[index];
                        return Chip(
                          label: Text(category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1,
                              style: BorderStyle.solid),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10.0,
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
          }),
    );
  }
}
