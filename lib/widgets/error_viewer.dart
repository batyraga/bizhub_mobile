import 'package:bizhub/widgets/button.dart';
import 'package:flutter/material.dart';

class BeautifyError extends StatelessWidget {
  final Function()? onRetry;
  const BeautifyError({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Kyncylyk doredi",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SecondaryButton(onPressed: onRetry, child: "Retry")
          ],
        ),
      ),
    );
  }
}
