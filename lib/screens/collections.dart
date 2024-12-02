import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/collections.model.dart';
import 'package:bizhub/shimmers/collections.shimmer.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/collection.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/screens/child_screens/filter_products/main.dart';
import 'package:bizhub/screens/child_screens/search_product.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({
    super.key,
  });

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  late String culture;
  late Future<List<Collection>> futureCollections;
  // final PagingController<int, List<Collection>> _pagingController =
  //     PagingController(firstPageKey: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    culture = getLanguageCode(
        EasyLocalization.of(context)!.currentLocale!.languageCode);

    futureCollections = loadCollections();
    // _pagingController.addPageRequestListener((pageKey) {
    //   final String culture = getLanguageCode(
    //       EasyLocalization.of(context)!.currentLocale!.languageCode);
    //   loadCollections(culture);
    // });
  }

  Future<List<Collection>> loadCollections() async {
    try {
      final result = await api.collections.getCollections(culture: culture);
      return result;
    } catch (err) {
      log("[loadCollections] - error - $err");
      BizhubFetchErrors.error();
      return Future.error(err);
    }
  }

  void onErrorCollection(err) {
    setState(() {
      futureCollections = Future.error(err);
    });
    BizhubFetchErrors.error();
  }

  Future onRefresh() async {
    setState(() {
      futureCollections = loadCollections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          scrolledUnderElevation: 2.0,
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.3),
          titleSpacing: defaultPadding,
          backgroundColor: Colors.white,
          title: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              ctx: context,
                              type: PageTransitionType.fade,
                              child: SearchProductRoutePage(
                                  parentContext: context)));
                    },
                    child: SizedBox(
                      height: 40.0,
                      child: TextField(
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Inter",
                            color: Color.fromRGBO(170, 170, 170, 1)),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15.0),
                            hintText: 'Search product',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    const BorderSide(color: Colors.black))),
                        enabled: false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            ctx: context,
                            type: PageTransitionType.fade,
                            child: FilterRoutePage(parentContext: context)));
                  },
                  borderRadius: BorderRadius.circular(100.0),
                  child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(
                        Icons.settings,
                        size: 25,
                        color: Colors.black,
                      )),
                )
              ],
            ),
          )),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<List<Collection>>(
            future: futureCollections,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                if (snapshot.data == null) {
                  // setState(() {
                  //   futureCollections = Future.error("failed to load data");
                  // });
                  return Container();
                }
                final List<Collection> collections = snapshot.data!;
                return ListView.separated(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final iteM = collections[index];
                      return CollectionWidget(
                        collection: iteM,
                        onError: onErrorCollection,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox();
                    },
                    itemCount: collections.length);
              } else if (snapshot.hasError) {
                return const Text("collections error");
              }
              return const DefaultScrollView(
                  padding: EdgeInsets.all(0.0), child: ShimmerCollections());
            }),
      ),
    );
  }
}
