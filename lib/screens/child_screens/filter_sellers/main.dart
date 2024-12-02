import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/screens/child_screens/filter_sellers/result.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/screens/child_screens/filter_sellers/location.dart';
import 'package:bizhub/screens/child_screens/filter_sellers/seller_type.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:page_transition/page_transition.dart';

class FilterSellersRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final List<String>? cities;
  final String? sellerType;
  final void Function(List<String>, String)? onSubmit;
  const FilterSellersRoutePage(
      {super.key,
      this.onSubmit,
      required this.parentContext,
      this.cities,
      this.sellerType});

  @override
  State<FilterSellersRoutePage> createState() => _FilterSellersRoutePageState();
}

class _FilterSellersRoutePageState extends State<FilterSellersRoutePage> {
  String only = "all";
  List<String> cities = <String>[];
  late Future<SellersFilterAggregations> futureAggregations;
  @override
  void initState() {
    super.initState();
    debugPrint(widget.cities.toString());
    if (widget.cities != null) {
      setState(() {
        cities = widget.cities!;
      });
    }
    if (widget.sellerType != null) {
      setState(() {
        only = widget.sellerType!;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureAggregations = loadFilterAggregations();
  }

  Future<SellersFilterAggregations> loadFilterAggregations() async {
    try {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      return await api.sellers.filterAggregations(culture: culture);
    } catch (err) {
      BizhubFetchErrors.error();

      return Future.error(err);
    }
  }

  void submit() {
    debugPrint("hi");
    if (widget.onSubmit != null) {
      return widget.onSubmit!(cities, only);
    }
    Navigator.push(
        context,
        PageTransition(
            ctx: context,
            type: PageTransitionType.fade,
            child: SellersFilterResultRoutePage(
              cities: cities,
              sellerType: only,
            )));
    // Navigator.pop(context);
  }

  Future onRefresh() async {
    if (widget.cities != null) {
      setState(() {
        cities = widget.cities!;
      });
    }
    if (widget.sellerType != null) {
      setState(() {
        only = widget.sellerType!;
      });
    }
    setState(() {
      futureAggregations = loadFilterAggregations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.filter.tr(),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  only = "all";
                  cities = [];
                });
              },
              child: const Text(LocaleKeys.clear).tr())
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<SellersFilterAggregations>(
            future: futureAggregations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final aggregations = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                final List<String>? cities_ =
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            LocationModalBottomSheet(
                                                state: cities,
                                                cities: aggregations.cities,
                                                parentContext: context),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20.0))));
                                setState(() {
                                  if (cities_ != null) {
                                    cities = cities_;
                                  } else {
                                    cities = [];
                                  }
                                });
                              },
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            LocaleKeys.city,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19.0),
                                          ).tr(),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            cities.isEmpty
                                                ? LocaleKeys.all.tr()
                                                : cities
                                                    .map((e) => aggregations
                                                        .cities
                                                        .singleWhere(
                                                            (element) =>
                                                                element.id == e)
                                                        .name)
                                                    .join(" , "),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.0,
                                                color: Color.fromRGBO(
                                                    104, 104, 149, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right_outlined,
                                      size: 35.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  ]),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () async {
                                final String? only_ =
                                    await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            SellerTypeModalBottomSheet(
                                                state: only,
                                                parentContext: context),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20.0))));
                                if (only_ != null) {
                                  setState(() {
                                    only = only_;
                                  });
                                }
                              },
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            LocaleKeys.sort,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19.0),
                                          ).tr(),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            only,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15.0,
                                                color: Color.fromRGBO(
                                                    104, 104, 149, 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right_outlined,
                                      size: 35.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: SecondaryButton(
                            child: LocaleKeys.showResults.tr(),
                            onPressed: submit),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Text("error doredi");
              }
              return const CircularProgressIndicator();
            }),
      ), // filter page
    );
  }
}
