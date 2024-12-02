import 'dart:developer';

import 'package:bizhub/config/api.dart';
import 'package:bizhub/custom_painters/manufacturer.custom_painter.dart';
import 'package:bizhub/helpers/language.dart';
import 'package:bizhub/models/sellers.model.dart';
import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/screens/child_screens/seller/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class SellerBioRichText extends StatelessWidget {
  final String text;
  const SellerBioRichText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          children: text.split(" ").map((e) {
        bool pro = false;
        bool phone = false;
        bool host = false;
        bool mail = false;

        if (e.startsWith("+") &&
            int.tryParse(e.substring(0, 1)) != null &&
            RegExp(r"^[+]", caseSensitive: false).hasMatch(e)) {
          pro = true;
          phone = true;
        } else if (RegExp(
                r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''')
            .hasMatch(e)) {
          pro = true;
          mail = true;
        } else if (RegExp(
          r"(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)",
        ).hasMatch(e)) {
          pro = true;
          host = true;
        }

        final recognizer = TapGestureRecognizer();
        recognizer.onTap = () async {
          log("clicked to `$e`");
          Uri? uri;

          if (phone) {
            uri = Uri.parse("tel:$e");
          } else if (host) {
            uri = Uri.parse(
                "${(e.startsWith("http://") || e.startsWith("https://")) ? "" : "https://"}$e");
          } else if (mail) {
            uri = Uri.parse("mailto:$e");
          }

          if (uri != null) {
            url_launcher.launchUrl(uri);
          }
        };

        return TextSpan(
            recognizer: pro ? recognizer : null,
            text: "$e ",
            style: TextStyle(
                height: 1.5,
                leadingDistribution: TextLeadingDistribution.even,
                color: pro ? Colors.blue : Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                fontFamily: "Nunito"));
      }).toList()),
    );
  }
}

class SellerCard extends StatefulWidget {
  final Seller seller;
  final bool isFavorited;
  const SellerCard({super.key, required this.seller, this.isFavorited = false});

  @override
  State<SellerCard> createState() => _SellerCardState();
}

class _SellerCardState extends State<SellerCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                ctx: context,
                type: PageTransitionType.fade,
                child: SellerDetailRoutePage(
                  parentContext: context,
                  sellerId: widget.seller.id,
                )));
      },
      child: Container(
        // Container-di
        height: 75,
        padding: const EdgeInsets.only(left: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xffE5E5E5))),
                  child: CircleAvatar(
                    radius: 25.0,
                    foregroundImage: CachedNetworkImageProvider(
                        "$cdnUrl${widget.seller.logo}"),
                  ),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.seller.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Dosis",
                              fontSize: 15)),
                      const SizedBox(
                        height: 3.5,
                      ),
                      Text(widget.seller.city.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              // fontFamily: "Inter",
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(141, 141, 219, 1),
                              fontSize: 13)),
                    ],
                  ),
                ),
                if (widget.seller.type == "manufacturer")
                  CustomPaint(
                    size: Size(20.0, (20.0 * 1).toDouble()),
                    painter: ManufacturerCustomPainter(),
                  )
              ]),
            ),
            FavoriteButtonForSeller(
                sellerId: widget.seller.id,
                isFavorite: context
                    .watch<Favorites>()
                    .isFavoriteSeller(widget.seller.id),
                onTap: () {
                  final String culture = getLanguageCode(
                      EasyLocalization.of(context)!
                          .currentLocale!
                          .languageCode);
                  context
                      .read<Favorites>()
                      .addOrRemoveFromFavoriteSellers(widget.seller, culture);
                })
          ],
        ),
      ),
    );
  }
}

class TopSellerCard extends StatelessWidget {
  final TopSeller seller;
  const TopSellerCard({
    Key? key,
    required this.seller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                ctx: context,
                type: PageTransitionType.fade,
                child: SellerDetailRoutePage(
                  parentContext: context,
                  sellerId: seller.id,
                )));
      },
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(color: defaultBorderColor),
        ),
        child: CircleAvatar(
          backgroundColor: shimmerBaseColor,
          radius: 25.0,
          // clipBehavior: Clip.hardEdge,
          // height: 50.0,
          // width: 50.0,
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(100.0),
          //     // shape: BoxShape.circle,
          //     border: Border.all(color: defaultBorderColor)),
          // borderRadius: BorderRadius.circular(100.0),
          foregroundImage: CachedNetworkImageProvider("$cdnUrl${seller.logo}"),
        ),
      ),
    );
  }
}
