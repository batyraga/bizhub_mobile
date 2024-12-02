import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/screens/child_screens/product_detail.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final void Function()? onClick;
  final bool? selected;
  final Product product;
  final bool showFavorite;
  final bool navigateToSeller;
  final bool? isRelatedProduct;
  final void Function()? onLongPress;
  const ProductCard(
      {super.key,
      this.onClick,
      this.onLongPress,
      this.selected,
      this.isRelatedProduct,
      this.showFavorite = true,
      this.navigateToSeller = true,
      required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    super.initState();
  }

  void openDetail() {
    Navigator.push(
        context,
        PageTransition(
            ctx: context,
            type: PageTransitionType.fade,
            child: ProductDetailRoutePage(
                parentContext: context,
                id: widget.product.id,
                navigateToSeller: widget.navigateToSeller)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: widget.onClick ?? openDetail,
      onLongPress: widget.onLongPress,
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        color: defaultBorderColor,
                        width: 1,
                        style: BorderStyle.solid)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(children: [
                        LayoutBuilder(builder: (context, constraints) {
                          return CachedNetworkImage(
                            height: constraints.maxWidth,
                            width: constraints.maxWidth,
                            fit: BoxFit.cover,
                            imageUrl: "$cdnUrl${widget.product.image}",
                            // (MediaQuery.of(context).size.width - 45.0) * 0.5,
                            // decoration: BoxDecoration(
                            //   // color: Colors.red,
                            //   image: DecorationImage(
                            //       image: CachedNetworkImageProvider(
                            //           "$cdnUrl${widget.product.image}"),
                            //       fit: BoxFit.scaleDown),
                            // ),
                          );
                        }),
                        if (widget.product.isNew)
                          Positioned(
                              top: 10.0,
                              left: 0,
                              child: Container(
                                color: const Color.fromRGBO(255, 199, 0, 1),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15.0),
                                child: const Text(
                                  LocaleKeys.NEW,
                                  style: TextStyle(
                                    fontFamily: "Dosis",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                  ),
                                ).tr(),
                              )),
                        if (widget.product.discount > 0)
                          Positioned(
                              bottom: 0.0,
                              right: 0,
                              child: Container(
                                color: const Color.fromRGBO(255, 0, 0, 1),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10.0),
                                child: Text(
                                  "-${widget.product.discount.toInt().toString()}%",
                                  style: const TextStyle(
                                    fontFamily: "Dosis",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.0,
                                  ),
                                ),
                              )),
                      ]),
                      Expanded(
                        child: Padding(
                          // color: Colors.red,
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisAlignment: widget.isRelatedProduct == true
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.heading,
                                maxLines: 2,
                                // textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Color.fromRGBO(110, 90, 209, 1),
                                    fontFamily: "Dosis",
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              if (widget.isRelatedProduct != true)
                                const SizedBox(
                                  height: 8.0,
                                ),
                              if (widget.isRelatedProduct != true)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          widget.product.price
                                              .toInt()
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Dosis",
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          width: 5.0,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 1.5),
                                          child: Text("TMT",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Dosis",
                                                  color: Color(0xffa1a1a1))),
                                        )
                                      ],
                                    ),
                                    if (widget.showFavorite)
                                      FavoriteButtonForProduct(
                                        productId: widget.product.id,
                                        isFavorite: context
                                            .watch<Favorites>()
                                            .isFavoriteProduct(
                                                widget.product.id),
                                        onTap: () {
                                          final String culture =
                                              getLanguageCode(
                                                  EasyLocalization.of(context)!
                                                      .currentLocale!
                                                      .languageCode);
                                          context
                                              .read<Favorites>()
                                              .addOrRemoveFromFavoriteProducts(
                                                  widget.product, culture);
                                        },
                                      )
                                  ],
                                )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.selected == true)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                        color: Colors.white.withOpacity(0.65),
                        border: Border.all(
                            color: defaultBorderColor,
                            width: 1,
                            style: BorderStyle.solid)),
                    width: 100,
                    height: 100,
                    child: Center(
                        child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Theme.of(context).colorScheme.primary),
                      child: const Center(
                          child: Icon(
                        Icons.check,
                        size: 30,
                        color: Colors.white,
                      )),
                    )),
                  ),
                ),
              if (widget.selected == true)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                        color: Colors.white.withOpacity(0.10),
                        border: Border.all(
                            color: defaultBorderColor,
                            width: 1,
                            style: BorderStyle.solid)),
                    width: 100,
                    height: 100,
                    child: Center(
                        child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Theme.of(context).colorScheme.primary),
                      child: const Center(
                          child: Icon(
                        Icons.check,
                        size: 30,
                        color: Colors.white,
                      )),
                    )),
                  ),
                )
            ]),
          ),
          if (widget.product.isChecking)
            Positioned(
                child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.60),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: defaultBorderColor),
              ),
              child: const Text(
                LocaleKeys.checking,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(110, 90, 209, 1),
                  fontSize: 18.0,
                ),
              ).tr(),
            )),
        ],
      ),
    );
  }
}

class DeleteProductBottomSheet extends StatefulWidget {
  final String productId;
  final String heading;
  const DeleteProductBottomSheet({
    Key? key,
    required this.productId,
    required this.heading,
  }) : super(key: key);

  @override
  State<DeleteProductBottomSheet> createState() =>
      _DeleteProductBottomSheetState();
}

class _DeleteProductBottomSheetState extends State<DeleteProductBottomSheet> {
  bool loading = false;

  Future<void> delete() async {
    setState(() {
      loading = true;
    });
    try {
      final bool s = await api.products.delete(productId: widget.productId);
      if (s == true) {
        Future.sync(() => Navigator.pop(context, true));
        return;
      }

      throw Exception("failed delete this product");
    } catch (err) {
      log("[deleteProduct] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.heading,
          style: const TextStyle(
            fontSize: 18.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        RedButton(
            onPressed: delete,
            loading: loading,
            child: "Yes, delete this product")
      ],
    );
  }
}
