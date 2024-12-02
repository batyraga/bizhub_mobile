import 'package:flutter/material.dart';

class BottomSheetButton extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Color color;
  final void Function()? onTap;
  final bool disableVerticalPadding;
  const BottomSheetButton(
      {super.key,
      required this.title,
      this.icon,
      this.color = Colors.black,
      this.onTap,
      this.disableVerticalPadding = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 15.0, vertical: disableVerticalPadding ? 0 : 12),
        child: Row(
          children: [
            if (icon != null) icon!,
            if (icon != null)
              const SizedBox(
                width: 15,
              ),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                  fontFamily: "Nunito",
                  color: color),
            )
          ],
        ),
      ),
    );
  }
}

class CustomModalBottomSheetTitle extends StatelessWidget {
  final String title;
  const CustomModalBottomSheetTitle({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

Future<T?> showCustomModalBottomSheet<T>(
    {required BuildContext context,
    bool disablePadding = false,
    bool isScrollControlled = true,
    required Widget Function(BuildContext context) builder}) async {
  return await showModalBottomSheet<T>(
      isScrollControlled: isScrollControlled,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: disablePadding == true ? 0.0 : 20.0,
            bottom: disablePadding == true
                ? MediaQuery.of(context).viewInsets.bottom
                : 20.0 + MediaQuery.of(context).viewInsets.bottom,
            right: disablePadding == true ? 0.0 : 20.0,
            left: disablePadding == true ? 0.0 : 20.0,
          ),
          child: builder(context),
        );
      },
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))));
}

Future<T?> showCustomModalBottomSheetWithTitle<T>(
    {required BuildContext context,
    required String title,
    required Widget Function(BuildContext) builder}) async {
  return await showCustomModalBottomSheet<T>(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 2.0,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            builder(context)
          ],
        );
      });
}
