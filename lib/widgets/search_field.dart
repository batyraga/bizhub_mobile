import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String? hintText;
  final Widget? suffix;
  final bool? enabled;
  final void Function()? onTap;
  final bool showSearchIcon;
  final bool showClearIcon;
  final void Function()? onClear;
  const SearchField(
      {super.key,
      this.hintText,
      this.enabled,
      this.onTap,
      this.suffix,
      this.showSearchIcon = true,
      this.showClearIcon = false,
      this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 1)),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              if (showSearchIcon)
                const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 25,
                ),
              GestureDetector(
                onTap: onTap,
                child: TextField(
                  enabled: enabled,
                  decoration: InputDecoration(
                      hintText: hintText,
                      suffix: suffix,
                      hintStyle: const TextStyle(fontSize: 15),
                      contentPadding: const EdgeInsets.only(
                          bottom: 8, top: 0, left: 6, right: 10),
                      border: InputBorder.none),
                ),
              ),
              if (showClearIcon && onClear != null)
                InkWell(
                  onTap: onClear,
                  child: const Icon(
                    Icons.close_outlined,
                    color: Colors.grey,
                  ),
                )
            ],
          ),
        ));
  }
}
