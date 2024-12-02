import 'package:flutter/material.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final void Function()? onBack;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool? disableDefaultElevationAnimation;
  const DefaultAppBar(
      {super.key,
      this.title,
      this.backgroundColor,
      this.disableDefaultElevationAnimation,
      this.bottom,
      this.actions,
      this.onBack})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          widget.backgroundColor ?? Colors.white, // transparent by default
      elevation: 0,
      foregroundColor: Colors.black,
      toolbarHeight: 60.0,
      leadingWidth: 50.0,
      bottom: widget.bottom,
      shadowColor: widget.disableDefaultElevationAnimation == true
          ? null
          : const Color.fromRGBO(0, 0, 0, 0.3),
      scrolledUnderElevation:
          widget.disableDefaultElevationAnimation == true ? null : 2.0,
      leading: ModalRoute.of(context)?.canPop == true
          ? InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: widget.onBack ??
                  () {
                    Navigator.pop(context);
                  },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back),
              ),
            )
          : null,
      titleSpacing: ModalRoute.of(context)?.canPop == true ? 0.0 : null,
      title: widget.title != null
          ? Text(
              widget.title!,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            )
          : null,
      actions: widget.actions,
    );
  }
}
