import 'package:flutter/material.dart';

class KeyValueWidget extends StatelessWidget {
  final String title;
  final String value;

  const KeyValueWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 17.0),
        )
      ],
    );
  }
}
