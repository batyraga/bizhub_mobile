// import 'dart:developer';

import 'package:bizhub/api/main.dart';
// import 'package:bizhub/config/constants.dart';
import 'package:bizhub/providers/auth.provider.dart';
// import 'package:bizhub/providers/favorites.provider.dart';
import 'package:bizhub/widgets/login_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final dynamic child;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final bool useDefaultText;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool? loading;
  final bool? disabled;
  const PrimaryButton(
      {super.key,
      this.disabled,
      required this.onPressed,
      required this.child,
      this.autofocus = false,
      this.onHover,
      this.onFocusChange,
      this.focusNode,
      this.onLongPress,
      this.useDefaultText = true,
      this.loading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            minimumSize: const Size.fromHeight(45),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0))),
        onPressed: ((loading == true) || (disabled == true)) ? null : onPressed,
        onFocusChange: onFocusChange,
        autofocus: autofocus,
        focusNode: focusNode,
        onHover: onHover,
        onLongPress: onLongPress,
        key: key,
        child: loading == true
            ? Container(
                height: 40.0,
                width: 40.0,
                padding: const EdgeInsets.all(10.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.0,
                ))
            : useDefaultText
                ? Text(child,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16.0))
                : child);
  }
}

class RedButton extends StatelessWidget {
  final void Function()? onPressed;
  final dynamic child;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final bool useDefaultText;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool? loading;
  final bool? disabled;
  const RedButton(
      {super.key,
      this.disabled,
      required this.onPressed,
      required this.child,
      this.autofocus = false,
      this.onHover,
      this.onFocusChange,
      this.focusNode,
      this.onLongPress,
      this.useDefaultText = true,
      this.loading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            minimumSize: const Size.fromHeight(45),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0))),
        onPressed: ((loading == true) || (disabled == true)) ? null : onPressed,
        onFocusChange: onFocusChange,
        autofocus: autofocus,
        focusNode: focusNode,
        onHover: onHover,
        onLongPress: onLongPress,
        key: key,
        child: loading == true
            ? Container(
                height: 40.0,
                width: 40.0,
                padding: const EdgeInsets.all(10.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.0,
                ))
            : useDefaultText
                ? Text(child,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16.0))
                : child);
  }
}

class SecondaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final dynamic child;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final bool useDefaultText;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool? loading;
  final bool? disabled;
  const SecondaryButton(
      {super.key,
      this.disabled,
      required this.onPressed,
      required this.child,
      this.autofocus = false,
      this.onHover,
      this.onFocusChange,
      this.focusNode,
      this.onLongPress,
      this.useDefaultText = true,
      this.loading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.onSecondary,
            minimumSize: const Size.fromHeight(45),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0))),
        onPressed: ((loading == true) || (disabled == true)) ? null : onPressed,
        onFocusChange: onFocusChange,
        autofocus: autofocus,
        focusNode: focusNode,
        onHover: onHover,
        onLongPress: onLongPress,
        key: key,
        child: loading == true
            ? Container(
                height: 40.0,
                width: 40.0,
                padding: const EdgeInsets.all(10.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.0,
                ))
            : useDefaultText
                ? Text(child,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16.0))
                : child);
  }
}

class FavoriteButtonForProduct extends StatefulWidget {
  final bool isFavorite;
  final String productId;
  final void Function() onTap;
  final bool disabled;
  const FavoriteButtonForProduct(
      {super.key,
      this.isFavorite = false,
      this.disabled = false,
      required this.productId,
      required this.onTap});

  @override
  State<FavoriteButtonForProduct> createState() =>
      _FavoriteButtonForProductState();
}

class _FavoriteButtonForProductState extends State<FavoriteButtonForProduct> {
  Future<bool> future = Future(() {
    return true;
  });

  Future<bool> onTap() async {
    final bool isAuth = context.read<Auth>().isAuthenticated;
    if (isAuth == false) {
      showLoginModal(context);
      return false;
    }
    final bool result = await api.auth.favorite(
        widget.isFavorite == true ? "delete" : "add",
        "product",
        widget.productId);
    if (result == true) {
      widget.onTap();
      return true;
    } else {
      const errorSnackBar = SnackBar(content: Text("kyncylyk doredi"));
      (() {
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: future,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.done ||
          //     snapshot.hasError) {
          return InkWell(
              borderRadius: BorderRadius.circular(100.0),
              onTap: widget.disabled
                  ? null
                  : () async {
                      setState(() {
                        future = onTap();
                      });
                    },
              child: Icon(
                widget.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_outlined,
                size: 18.0,
                color: widget.isFavorite
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.black,
              ));
          // }
          // return const SizedBox(
          // width: 24.0, height: 24.0, child: CircularProgressIndicator());
        });
  }
}

class FavoriteButtonForSeller extends StatefulWidget {
  final bool isFavorite;
  final String sellerId;
  final void Function() onTap;
  final bool disabled;
  const FavoriteButtonForSeller(
      {super.key,
      this.isFavorite = false,
      required this.sellerId,
      this.disabled = false,
      required this.onTap});

  @override
  State<FavoriteButtonForSeller> createState() =>
      _FavoriteButtonForSellerState();
}

class _FavoriteButtonForSellerState extends State<FavoriteButtonForSeller> {
  Future<bool> future = Future(() {
    return true;
  });

  Future<bool> onTap() async {
    final bool isAuth = context.read<Auth>().isAuthenticated;
    if (isAuth == false) {
      showLoginModal(context);
      return false;
    }
    final bool result = await api.auth.favorite(
        widget.isFavorite == true ? "delete" : "add",
        "seller",
        widget.sellerId);
    if (result == true) {
      widget.onTap();
      return true;
    } else {
      const errorSnackBar = SnackBar(content: Text("kyncylyk doredi"));
      (() {
        ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: future,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.done ||
          //     snapshot.hasError) {
          return InkWell(
            onTap: widget.disabled
                ? null
                : () async {
                    setState(() {
                      future = onTap();
                    });
                  },
            child: Container(
              padding: const EdgeInsets.only(right: 15.0, left: 20.0),
              height: 75,
              // width: 50,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                        widget.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_outline_outlined,
                        color: widget.isFavorite
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.black),
                  ]),
            ),
          );
          // }
          // return InkWell(
          // child: Container(
          //   padding: const EdgeInsets.only(right: 15.0, left: 20.0),
          //   height: 75,
          //   // width: 50,
          //   child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: const [
          //         SizedBox(
          //             width: 24.0,
          //             height: 24.0,
          //             child: CircularProgressIndicator())
          //       ]),
          // ),
          // );
        });
  }
}

class FavoriteButtonWithCount extends StatefulWidget {
  final bool isFavorite;
  final String id;
  final String type;
  final void Function(int newLikes) onTap;
  final int likes;
  final double padding;
  final bool disabled;
  final double? iconSize;
  const FavoriteButtonWithCount(
      {super.key,
      required this.likes,
      required this.type,
      this.disabled = false,
      this.iconSize,
      this.isFavorite = false,
      this.padding = 5.0,
      required this.id,
      required this.onTap});

  @override
  State<FavoriteButtonWithCount> createState() =>
      _FavoriteButtonWithCountState();
}

class _FavoriteButtonWithCountState extends State<FavoriteButtonWithCount> {
  // int likes = 0;
  Future<bool> future = Future(() {
    return true;
  });

  Future<bool> onTap() async {
    try {
      // await Future.delayed(const Duration(seconds: 10));
      final bool isAuth = context.read<Auth>().isAuthenticated;
      if (isAuth == false) {
        showLoginModal(context);
        return false;
      }
      final bool result = await api.auth.favorite(
          widget.isFavorite == true ? "delete" : "add", widget.type, widget.id);

      if (result == true) {
        // setState(() {
        //   if (widget.isFavorite == true) {
        //     likes--;
        //   } else {
        //     likes++;
        //   }
        // });
        widget.onTap(
            widget.isFavorite == true ? widget.likes - 1 : widget.likes + 1);
        return true;
      } else {
        Future.sync(() {
          const errorSnackBar = SnackBar(content: Text("kyncylyk doredi"));
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        });
        return false;
      }
    } catch (err) {
      return Future.error(err);
    }
  }

  @override
  void initState() {
    super.initState();
    // likes = widget.likes;
  }

  void tap() {
    setState(() {
      future = onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: future,
        builder: (context, snapshot) {
          // log(snapshot.connectionState.toString());
          // if (snapshot.connectionState == ConnectionState.done ||
          //     snapshot.hasError) {
          return InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: widget.disabled ? null : tap,
              // style: TextButton.styleFrom(
              //     surfaceTintColor: Colors.red,
              //     // shadowColor: ,
              //     padding: const EdgeInsets.all(0),
              //     // shadowColor: Colors.red,
              //     // padding:
              //     //     const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
              //     minimumSize: Size.zero,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5.0)),
              //     backgroundColor: widget.isFavorite
              //         ? Colors.red[50]
              //         : Colors.transparent),

              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Icon(
                      widget.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_outlined,
                      color: widget.isFavorite
                          ? const Color.fromRGBO(244, 67, 54, 1)
                          : Colors.black,
                      size: widget.iconSize != null ? widget.iconSize! : 18.0,
                    ),
                    SizedBox(
                      width: widget.padding,
                    ),
                    Text(
                      "${widget.likes}",
                      style: TextStyle(
                          fontSize: 13.0,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          color: widget.isFavorite ? Colors.red : Colors.black),
                    )
                  ],
                ),
              ));
          // } else {
          // return TextButton(
          //     onPressed: null,
          //     style: TextButton.styleFrom(
          //         padding:
          //             const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
          //         minimumSize: Size.zero,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(100.0)),
          //         backgroundColor: widget.isFavorite
          //             ? Colors.red[50]
          //             : Colors.transparent),
          //     child: Row(
          //       children: [
          //         const Padding(
          //           padding: EdgeInsets.all(2.0),
          //           child: SizedBox(
          //               width: 20.0,
          //               height: 20.0,
          //               child: CircularProgressIndicator(
          //                 strokeWidth: 2.0,
          //               )),
          //         ),
          //         SizedBox(
          //           width: widget.padding,
          //         ),
          //         Text(
          //           "${widget.likes}",
          //           style: TextStyle(
          //               fontSize: 16,
          //               color: widget.isFavorite ? Colors.red : Colors.black),
          //         )
          //       ],
          //     ));
          // }
        });
  }
}

class FavoriteButtonWithCountForSeller extends StatefulWidget {
  final bool isFavorite;
  final String sellerId;
  final void Function(int newLikes) onTap;
  final int likes;
  final double padding;
  final bool disabled;
  const FavoriteButtonWithCountForSeller(
      {super.key,
      required this.likes,
      this.isFavorite = false,
      this.padding = 5.0,
      this.disabled = false,
      required this.sellerId,
      required this.onTap});

  @override
  State<FavoriteButtonWithCountForSeller> createState() =>
      _FavoriteButtonWithCountForSellerState();
}

class _FavoriteButtonWithCountForSellerState
    extends State<FavoriteButtonWithCountForSeller> {
  // int likes = 0;
  Future<bool> future = Future(() {
    return true;
  });

  Future<bool> onTap() async {
    try {
      final bool isAuth = context.read<Auth>().isAuthenticated;
      if (isAuth == false) {
        showLoginModal(context);
        return false;
      }
      final bool result = await api.auth.favorite(
          widget.isFavorite == true ? "delete" : "add",
          "seller",
          widget.sellerId);

      if (result == true) {
        widget.onTap(
            widget.isFavorite == true ? widget.likes - 1 : widget.likes + 1);
        return true;
      } else {
        Future.sync(() {
          const errorSnackBar = SnackBar(content: Text("kyncylyk doredi"));
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        });
        return false;
      }
    } catch (err) {
      return Future.error(err);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void tap() {
    setState(() {
      future = onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: future,
        builder: (context, snapshot) {
          // log(snapshot.connectionState.toString());
          // if (snapshot.connectionState == ConnectionState.done ||
          //     snapshot.hasError) {
          return ElevatedButton(
              onPressed: widget.disabled
                  ? null
                  : () async {
                      setState(() {
                        future = onTap();
                      });
                    },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: const Color(0xffF6F6F6),
                  shadowColor: Colors.white,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color(0xffE5E5E5),
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline_outlined,
                    color: widget.isFavorite
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.black,
                    size: 18.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "${widget.likes}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ));
          // } else {
          //   return ElevatedButton(
          //       onPressed: null,
          //       style: ElevatedButton.styleFrom(
          //           elevation: 0,
          //           primary: Colors.white,
          //           shadowColor: Colors.white,
          //           onPrimary: Colors.black,
          //           shape: RoundedRectangleBorder(
          //               side: const BorderSide(
          //                   color: defaultBorderColor,
          //                   width: 1,
          //                   style: BorderStyle.solid),
          //               borderRadius: BorderRadius.circular(5.0))),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           const SizedBox(
          //               width: 18.0,
          //               height: 18.0,
          //               child: CircularProgressIndicator(
          //                 strokeWidth: 2.0,
          //               )),
          //           const SizedBox(
          //             width: 6,
          //           ),
          //           Text("${widget.likes}")
          //         ],
          //       ));
          // }
        });
  }
}

class SubmitButtonBuilder extends StatelessWidget {
  final Widget Function(BuildContext, bool) builder;
  const SubmitButtonBuilder({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(builder: (context, f, child) {
      return builder(
        context,
        f.valid,
      );
    });
  }
}
