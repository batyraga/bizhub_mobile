import 'package:flutter/material.dart';

class FilterBareItem extends StatefulWidget {
  final String title;
  final Widget child;
  const FilterBareItem({super.key, required this.child, required this.title});

  @override
  State<FilterBareItem> createState() => _FilterBareItemState();
}

class _FilterBareItemState extends State<FilterBareItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
        ),
        const SizedBox(
          height: 6.0,
        ),
        widget.child
      ],
    );
  }
}
