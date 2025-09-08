import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/dynamic_links.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/main.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/chat.service.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/screens/child_screens/seller/main.dart';
import 'package:bizhub/screens/child_screens/view_image.dart';
import 'package:bizhub/screens/user_profile/child_screens/edit_product.dart';
import 'package:bizhub/widgets/bizhub_fetch_error_detector.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/item_status_cards.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

class PrepareTextForSendProductToSeller extends StatefulWidget {
  final Seller seller;
  const PrepareTextForSendProductToSeller({
    Key? key,
    required this.seller,
  }) : super(key: key);

  @override
  State<PrepareTextForSendProductToSeller> createState() =>
      _PrepareTextForSendProductToSellerState();
}

class _PrepareTextForSendProductToSellerState
    extends State<PrepareTextForSendProductToSeller> {
  final TextEditingController textController = TextEditingController();

  void send() async {
    final text = textController.text.trim();
    if (text.isEmpty) {
      return;
    }

    Navigator.pop(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffE5E5E5))),
              child: CircleAvatar(
                radius: 25.0,
                foregroundImage:
                    CachedNetworkImageProvider("$cdnUrl${widget.seller.logo}"),
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.seller.name,
                    style: const TextStyle(
                        fontFamily: "Dosis",
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0)),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  widget.seller.city.name,
                  style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(141, 141, 219, 1)),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        TextField(
          controller: textController,
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(
          height: 20.0,
        ),
        PrimaryButton(onPressed: send, child: LocaleKeys.submit.tr()),
      ],
    );
  }
}

class ProductDetailRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final String id;
  final bool navigateToSeller;
  const ProductDetailRoutePage(
      {super.key,
      required this.parentContext,
      this.navigateToSeller = true,
      required this.id});

  @override
  State<ProductDetailRoutePage> createState() => _ProductDetailRoutePageState();
}

class _ProductDetailRoutePageState extends State<ProductDetailRoutePage> {
  int _activeProductImageIndex = 0;
  late Future<ProductDetail> futureProduct;
  int _likes = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();

    futureProduct = loadProductDetail();
  }

  Future<ProductDetail> loadProductDetail() async {
    try {
      final String culture = getLang(context);

      final product =
          await api.products.getProductDetail(id: widget.id, culture: culture);
      setState(() {
        _likes = product.likes;
      });
      return product;
    } catch (err) {
      log("[loadProductDetail] - error - $err");
      BizhubFetchErrors.error();

      return Future.error(err);
    }
  }

  Future onRefresh() async {
    setState(() {
      _activeProductImageIndex = 0;
      futureProduct = loadProductDetail();
    });
  }

  shareProduct(Product product) async {
    Uri link = Uri.parse("$apiUrl/links?productId=${product.id}");

    final params = DynamicLinkParameters(
        link: link,
        uriPrefix: DynamicLinksConfig.urlPrefix,
        androidParameters: const AndroidParameters(
          packageName: "com.example.bizhub",
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: product.heading,
          imageUrl: Uri.parse("$cdnUrl${product.image}"),
          description: "Click & read more",
        ));

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(params);

    final box =
        (await Future.sync(() => context.findRenderObject())) as RenderBox?;

    await Share.share(dynamicLink.shortUrl.toString(),
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: FutureBuilder<ProductDetail>(
              future: futureProduct,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final ProductDetail product = snapshot.data!;
                  final reducedProduct = product.reduce();
                  return SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        SizedBox(
                          height: MediaQuery.of(context).padding.top,
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CarouselSlider(
                                carouselController: _carouselController,
                                items: product.images.map((e) {
                                  return Hero(
                                    tag: "imageViewer[$e]",
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                ctx: context,
                                                type: PageTransitionType.fade,
                                                child: ViewImageRoutePage(
                                                  name: e,
                                                  imageUrl: "$cdnUrl$e",
                                                )));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: "$cdnUrl$e",
                                        width: double.infinity,
                                        height: 280.0,
                                        fit: BoxFit.cover,
                                        placeholder: (context, _) => Container(
                                            height: 280.0,
                                            alignment: Alignment.center,
                                            child:
                                                const CircularProgressIndicator()),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                    scrollPhysics: product.images.length == 1
                                        ? const NeverScrollableScrollPhysics()
                                        : null,
                                    height: 280.0,
                                    autoPlay: product.images.length == 1
                                        ? false
                                        : true,
                                    viewportFraction: 1,
                                    onPageChanged: (index, _) {
                                      setState(() {
                                        _activeProductImageIndex = index;
                                      });
                                    })),
                            if (product.images.length != 1)
                              Positioned(
                                  bottom: 10.0,
                                  child: AnimatedSmoothIndicator(
                                      onDotClicked: (index) {
                                        setState(() {
                                          _activeProductImageIndex = index;
                                          _carouselController
                                              .animateToPage(index);
                                        });
                                      },
                                      effect: CustomizableEffect(
                                          spacing: 5.0,
                                          dotDecoration: DotDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: const Color.fromRGBO(
                                                64, 64, 124, 0.1),
                                            // color: const Color.fromRGBO(
                                            //     255, 255, 255, 0.5),
                                            height: 3.0,
                                            width: 6.0,
                                            // dotBorder: const DotBorder(
                                            //     color: Color.fromARGB(
                                            //         255, 218, 218, 218)),
                                          ),
                                          activeDotDecoration: DotDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            color: const Color.fromRGBO(
                                                64, 64, 124, 0.1),
                                            // color: const Color.fromRGBO(
                                            //     255, 255, 255, 0.5),
                                            height: 3.0,
                                            width: 25.0,
                                            // dotBorder: const DotBorder(
                                            //     color: Color.fromARGB(
                                            //         255, 218, 218, 218)),
                                          )
                                          // type: WormType.thin,
                                          // dotColor:
                                          //     Color.fromRGBO(255, 255, 255, 0.5),
                                          // activeDotColor:
                                          //     Color.fromRGBO(255, 255, 255, 0.5),
                                          ),
                                      activeIndex: _activeProductImageIndex,
                                      count: product.images.length)),
                            if (product.discount > 0)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  color: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  child: Text(
                                    "${product.discount}%",
                                    style: const TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 15.0,
                              left: 15.0,
                              child: Material(
                                color: Colors.transparent,
                                child: GestureDetector(
                                  // splashColor:
                                  //     Theme.of(context).colorScheme.secondary,
                                  onTap: () {
                                    Navigator.pop(widget.parentContext);
                                  },
                                  // borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      // color: Colors.red,
                                      color: const Color.fromRGBO(
                                          64, 64, 124, 0.1),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 20.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        if (product.isChecking == false)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, left: 15.0, right: 15.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    FavoriteButtonWithCount(
                                      id: product.id,
                                      likes: _likes,
                                      iconSize: 20.0,
                                      onTap: (newLikes) {
                                        final String culture = getLanguageCode(
                                            EasyLocalization.of(context)!
                                                .currentLocale!
                                                .languageCode);
                                        context
                                            .read<Favorites>()
                                            .addOrRemoveFromFavoriteProducts(
                                                reducedProduct, culture);
                                        setState(() {
                                          _likes = newLikes;
                                        });
                                      },
                                      disabled: (product.seller.id ==
                                          context
                                              .watch<Auth>()
                                              .currentUser
                                              ?.sellerId),
                                      type: "product",
                                      isFavorite: context
                                          .watch<Favorites>()
                                          .isFavoriteProduct(product.id),
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    TextButton(
                                        onPressed: null,
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3.5, horizontal: 4),
                                            minimumSize: Size.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0))),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.black,
                                              size: 20.0,
                                            ),
                                            const SizedBox(
                                              width: 3.5,
                                            ),
                                            Text(
                                              product.viewed.toString(),
                                              style: const TextStyle(
                                                  fontSize: 13.0,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ))
                                  ],
                                ),
                                Row(
                                  children: (product.seller.id ==
                                          context
                                              .watch<Auth>()
                                              .currentUser
                                              ?.sellerId)
                                      ? [
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            onTap: () async {
                                              log("product discount => ${product.discountDetail}");

                                              if (product.discount > 0) {
                                                final status =
                                                    await showCustomModalBottomSheetWithTitle<
                                                            bool>(
                                                        title: "Discount",
                                                        context: context,
                                                        builder: (_) {
                                                          return RemoveDiscountFromProduct(
                                                            discountDetail: product
                                                                .discountDetail!,
                                                            productId:
                                                                product.id,
                                                          );
                                                        });
                                                if (status == true) {
                                                  setState(() {
                                                    _activeProductImageIndex =
                                                        0;
                                                    futureProduct =
                                                        loadProductDetail();
                                                  });
                                                }
                                              } else {
                                                final status =
                                                    await showCustomModalBottomSheetWithTitle<
                                                            bool>(
                                                        title: "Set Discount",
                                                        context: context,
                                                        builder: (_) {
                                                          return SetDiscountToProduct(
                                                            productId:
                                                                product.id,
                                                            price:
                                                                product.price,
                                                          );
                                                        });

                                                if (status == true) {
                                                  setState(() {
                                                    _activeProductImageIndex =
                                                        0;
                                                    futureProduct =
                                                        loadProductDetail();
                                                  });
                                                }
                                              }
                                            },
                                            child: Icon(
                                              product.discount > 0
                                                  ? Icons.discount_rounded
                                                  : Icons.discount_outlined,
                                              size: 20.0,
                                              color: product.discount > 0
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 15.0),
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            onTap: () async {
                                              final bool? s = await Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      ctx: context,
                                                      type: PageTransitionType
                                                          .fade,
                                                      child:
                                                          EditProductRoutePage(
                                                              id: widget.id,
                                                              parentContext:
                                                                  context)));
                                              if (s == true) {
                                                onRefresh();
                                              }
                                            },
                                            child: const Icon(
                                              Icons.edit_outlined,
                                              size: 20.0,
                                            ),
                                          ),
                                        ]
                                      : [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            onTap: () async {
                                              final String? text =
                                                  await showCustomModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          PrepareTextForSendProductToSeller(
                                                            seller: Seller(
                                                                name: product
                                                                    .seller
                                                                    .name,
                                                                logo: product
                                                                    .seller
                                                                    .logo,
                                                                id: product
                                                                    .seller.id,
                                                                city: product
                                                                    .seller
                                                                    .city!,
                                                                type: product
                                                                    .seller
                                                                    .type),
                                                          ));

                                              if (text != null) {
                                                Future.sync(() {
                                                  context
                                                      .read<ChatService>()
                                                      .sendProduct(
                                                          product.seller.id,
                                                          reducedProduct,
                                                          text);
                                                });
                                              }
                                            },
                                            child: const Icon(
                                              Icons.send_outlined,
                                              size: 20.0,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                          InkWell(
                                              splashColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                shareProduct(reducedProduct);
                                              },
                                              child: const Icon(
                                                Icons.share,
                                                color: Colors.black,
                                                size: 20.0,
                                              )),
                                        ],
                                )
                              ],
                            ),
                          ),
                        if (product.isChecking) const ItemCheckingCard(),
                        if (product.isRejected)
                          const ItemRejectedCard(type: "product"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        text:
                                            "${product.discount > 0 && product.discountDetail != null ? (product.price - product.discountDetail!.price).toStringAsFixed(2) : product.price.toStringAsFixed(2)} ",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Dosis",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 25.0),
                                        children: [
                                      if (product.discount > 0 &&
                                          product.discountDetail != null)
                                        TextSpan(
                                            text: product.price
                                                .toStringAsFixed(2),
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.red,
                                                fontFamily: "Dosis",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.0)),
                                      TextSpan(
                                        text:
                                            "${product.discount > 0 ? "  " : ""}TMT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                            fontFamily: "Dosis",
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      )
                                    ])),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  product.heading,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0,
                                      fontFamily: "Dosis"),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Column(
                                  children: product.attributes.map((attribute) {
                                    // final ProductAttribute attribute =
                                    //     product.attributes[index];
                                    // return Text(attribute.id);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "${attribute.attributeDetail.name}:",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Dosis",
                                                    fontSize: 16.0,
                                                    color: Color.fromRGBO(
                                                        85, 85, 85, 1)),
                                              )),
                                          Expanded(
                                              flex: 3,
                                              child: Text(
                                                "${attribute.value} ${attribute.unit}",
                                                style: const TextStyle(
                                                    fontFamily: "Nunito",
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.0,
                                                    color: Color.fromRGBO(
                                                        110, 90, 209, 1)),
                                              ))
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                Text(
                                  "${LocaleKeys.category.tr()}:",
                                  style: const TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: "Dosis",
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "${product.category.parent.name} / ${product.category.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      color: Color.fromRGBO(110, 90, 209, 1)),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  "${LocaleKeys.brand.tr()}:",
                                  style: const TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: "Dosis",
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "${product.brand.parent.name} / ${product.brand.name}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      color: Color.fromRGBO(110, 90, 209, 1)),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${LocaleKeys.moreDetails.tr()}:",
                                style: const TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: "Dosis",
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                product.moreDetails,
                                style: const TextStyle(
                                    height: 1.5,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(
                                height: 10.0,
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (product.seller.id ==
                                  context.watch<Auth>().currentUser?.sellerId)
                              ? null
                              : widget.navigateToSeller
                                  ? () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              ctx: context,
                                              type: PageTransitionType.fade,
                                              child: SellerDetailRoutePage(
                                                parentContext: context,
                                                sellerId: product.seller.id,
                                              )));
                                    }
                                  : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xffE5E5E5))),
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    foregroundImage: CachedNetworkImageProvider(
                                        "$cdnUrl${product.seller.logo}"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.seller.name,
                                        style: const TextStyle(
                                            fontFamily: "Dosis",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0)),
                                    if (!product.seller.isReporterBee())
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                    if (!product.seller.isReporterBee())
                                      Text(
                                        product.seller.city!.name,
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromRGBO(
                                                141, 141, 219, 1)),
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ]));
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Error doredi"),
                      const SizedBox(
                        height: 10.0,
                      ),
                      PrimaryButton(
                          onPressed: () {
                            futureProduct = loadProductDetail();
                          },
                          child: "Retry")
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ));
  }
}

class RemoveDiscountFromProduct extends StatefulWidget {
  final String productId;
  final ProductDiscountData discountDetail;

  const RemoveDiscountFromProduct({
    Key? key,
    required this.discountDetail,
    required this.productId,
  }) : super(key: key);

  @override
  State<RemoveDiscountFromProduct> createState() =>
      _RemoveDiscountFromProductState();
}

class _RemoveDiscountFromProductState extends State<RemoveDiscountFromProduct> {
  bool loading = false;

  Future<void> removeDiscount() async {
    setState(() {
      loading = true;
    });

    try {
      final bool status = await api.products.removeDiscountFromProduct(
        productId: widget.productId,
      );
      log("[removeDiscount] - status - $status");

      if (status == true) {
        Future.sync(() => Navigator.pop(context, true));
        return;
      }

      throw Exception("failed remove discount from product");
    } catch (err) {
      log("[removeDiscount] - err - $err");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.discountDetail.price} TMT / ${widget.discountDetail.percent}% - ${widget.discountDetail.duration} ${widget.discountDetail.durationType}",
            style: const TextStyle(
                color: Color(0xff555555),
                fontSize: 18.0,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 20.0,
          ),
          RedButton(
              loading: loading,
              onPressed: removeDiscount,
              child: LocaleKeys.removeDiscount.tr())
        ]);
  }
}

class SetDiscountToProduct extends StatefulWidget {
  final String productId;
  final double price;
  const SetDiscountToProduct({
    Key? key,
    required this.productId,
    required this.price,
  }) : super(key: key);

  @override
  State<SetDiscountToProduct> createState() => _SetDiscountToProductState();
}

class _SetDiscountToProductState extends State<SetDiscountToProduct> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  String durationType = "hour";
  String type = "price";

  bool loading = false;

  Future<void> setDiscountToProduct() async {
    final double price = double.parse(_priceController.value.text);
    final double percent = double.parse(_percentController.value.text);
    final int duration = int.parse(_durationController.value.text);

    if (price <= 0 || price > widget.price) {
      return;
    } else if (percent <= 0 || percent > 100) {
      return;
    } else if (duration <= 0) {
      return;
    }

    final data = ProductDiscountData(
        duration: duration,
        durationType: durationType,
        percent: percent,
        type: type,
        price: price);

    setState(() {
      loading = true;
    });
    try {
      final bool status = await api.products.setDiscountToProduct(
        productId: widget.productId,
        data: data,
      );

      log("[setDiscountToProduct] - status - $status");

      if (status == true) {
        Future.sync(() => Navigator.pop(context, true));
        return;
      }

      throw Exception("failed set discount to product");
    } catch (err) {
      log("[setDiscountToProduct] - error - $err");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$err")));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      splashRadius: 0.0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: type == "price",
                      onChanged: (n) {
                        setState(() {
                          type = n == true ? "price" : "percent";
                        });
                      }),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    LocaleKeys.price.tr(),
                    style: TextStyle(
                      color: type == "price" ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
                child: CustomizedTextField(
              suffixText: "TMT",
              enabled: type == "price",
              keyboardType: TextInputType.number,
              controller: _priceController,
              onSubmitted: (v) {
                final double price = double.parse(v);
                final double percent = price / (widget.price / 100);
                _percentController.text = percent.toStringAsFixed(2);
              },
            )),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Checkbox(
                      splashRadius: 0.0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: type == "percent",
                      onChanged: (n) {
                        setState(() {
                          type = n == true ? "percent" : "price";
                        });
                      }),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    LocaleKeys.percent.tr(),
                    style: TextStyle(
                      color: type == "percent" ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
                child: CustomizedTextField(
              suffixText: "%",
              enabled: type == "percent",
              controller: _percentController,
              onSubmitted: (v) {
                final double percent = double.parse(v);
                final double price = (widget.price / 100) * percent;
                _priceController.text = price.toStringAsFixed(2);
              },
              keyboardType: TextInputType.number,
            )),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          LocaleKeys.duration.tr(),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: CustomizedTextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
            )),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
                child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                alignment: Alignment.center,
                value: durationType,
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      durationType = v;
                    });
                  }
                },
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                // Replace `itemHeight` with `menuItemStyleData`:
                menuItemStyleData: MenuItemStyleData(
                  height: 46.0,
                ),
                // Replace `buttonPadding` and `buttonDecoration` with `buttonStyleData`:
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(246, 246, 246, 1),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                    ),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "hour", child: Text("Hour")),
                  DropdownMenuItem(value: "day", child: Text("Day")),
                  DropdownMenuItem(value: "month", child: Text("Month")),
                ],
              ),
            )), // discount edilmedik!
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        PrimaryButton(
            onPressed: setDiscountToProduct,
            loading: loading,
            child: LocaleKeys.setDiscount.tr())
      ],
    );
  }
}
