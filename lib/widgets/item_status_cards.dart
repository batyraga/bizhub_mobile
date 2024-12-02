import 'package:flutter/material.dart';

class ItemCheckingCard extends StatelessWidget {
  const ItemCheckingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color.fromRGBO(110, 90, 209, 0.15),
        ),
        padding: const EdgeInsets.all(10.0),
        child: const Text(
          "Your product is being checked. Wait, please!",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Color.fromRGBO(110, 90, 209, 1)),
        ),
      ),
    );
  }
}

class ItemRejectedCard extends StatelessWidget {
  final String type;
  const ItemRejectedCard({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 15.0,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color.fromRGBO(255, 0, 0, 0.15),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Your $type has been rejected. Change content, please!",
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Color.fromRGBO(255, 0, 0, 1)),
        ),
      ),
    );
  }
}
