import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/product.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/models/collections.model.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/screens/child_screens/collection_detail.dart';
import 'package:bizhub/shimmers/grid_view_for_products.shimmer.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/widgets/product_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:page_transition/page_transition.dart';

class CollectionWidget extends StatefulWidget {
  final Collection collection;
  final void Function(dynamic err) onError;

  const CollectionWidget(
      {super.key, required this.collection, required this.onError});

  @override
  State<CollectionWidget> createState() => _CollectionWidgetState();
}

class _CollectionWidgetState extends State<CollectionWidget> {
  final PagingController<int, Product> _pagingController =
      PagingController<int, Product>(firstPageKey: 0);
  bool _isClosed = false;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      final String culture = getLanguageCode(
          EasyLocalization.of(context)!.currentLocale!.languageCode);
      loadCollections(culture);
    });
  }

  Future<void> loadCollections(culture) async {
    try {
      final result = await api.collections
          .getCollection(culture: culture, path: widget.collection.path);
      debugPrint('$result');
      if (result.isEmpty) {
        setState(() {
          _isClosed = true;
        });
        return;
      }
      _pagingController.appendLastPage(result);
    } catch (err) {
      debugPrint('$err');
      widget.onError(err);
      _pagingController.error = err;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isClosed) {
      return Container();
    } else {
      return Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.collection.name,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
                InkWell(
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              ctx: context,
                              type: PageTransitionType.fade,
                              child: CollectionDetailRoutePage(
                                  collectionPath: widget.collection.path,
                                  title: widget.collection.name)));
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 5, top: 5, right: 0, left: 5),
                        child: const Text(LocaleKeys.seeAll,
                                style: TextStyle(
                                    fontFamily: "Dosis",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(110, 90, 209, 1)))
                            .tr()))
              ],
            ),
          ),
          PagedGridView<int, Product>(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              physics: const NeverScrollableScrollPhysics(),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                  newPageProgressIndicatorBuilder: (context) =>
                      const ShimmerGridViewForProducts(
                        disablePadding: true,
                      ),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const ShimmerGridViewForProducts(
                        disablePadding: true,
                      ),
                  itemBuilder: (context, item, index) {
                    return ProductCard(product: item);
                  }),
              gridDelegate: productGridDelegate),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }
  }
}
