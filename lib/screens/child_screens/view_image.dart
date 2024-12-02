import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImageRoutePage extends StatefulWidget {
  final String name;
  final String imageUrl;
  const ViewImageRoutePage(
      {super.key, required this.name, required this.imageUrl});

  @override
  State<ViewImageRoutePage> createState() => _ViewImageRoutePageState();
}

class _ViewImageRoutePageState extends State<ViewImageRoutePage> {
  final controller = PhotoViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: PhotoView(
        enableRotation: true,
        enablePanAlways: true,
        gaplessPlayback: true,
        controller: controller,
        heroAttributes:
            PhotoViewHeroAttributes(tag: "imageViewer[${widget.name}]"),
        imageProvider: CachedNetworkImageProvider(widget.imageUrl),
      ),
      // body: CachedNetworkImage(
      //     width: MediaQuery.of(context).size.width,
      //     fit: BoxFit.contain,
      //     alignment: Alignment.center,
      //     imageUrl: widget.imageUrl),
    );
  }
}
