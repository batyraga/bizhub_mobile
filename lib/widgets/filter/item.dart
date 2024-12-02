import 'package:flutter/material.dart';

class FilterItem extends StatefulWidget {
  final String title;
  final String description;
  final void Function()? onTap;
  const FilterItem(
      {super.key,
      required this.onTap,
      required this.description,
      required this.title});

  @override
  State<FilterItem> createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                widget.description,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Color.fromRGBO(104, 104, 149, 1)),
              )
            ],
          ),
        ),
        Icon(
          Icons.arrow_right_outlined,
          size: 35.0,
          color: Theme.of(context).colorScheme.primary,
        )
      ]),
    );
  }
}
