import 'package:bizhub/widgets/button.dart';
import 'package:flutter/material.dart';

class FetchingError extends StatefulWidget {
  final Future<void> Function() onRefresh;

  const FetchingError({Key? key, required this.onRefresh}) : super(key: key);

  @override
  State<FetchingError> createState() => _FetchingErrorState();
}

class _FetchingErrorState extends State<FetchingError> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/kerror.png"),
          const SizedBox(
            height: 50.0,
          ),
          const Text("Oops!"),
          const SizedBox(
            height: 20.0,
          ),
          const Text("No internet connection found, check your connection."),
          const SizedBox(
            height: 30.0,
          ),
          PrimaryButton(
              loading: loading,
              onPressed: () async {
                setState(() {
                  loading = true;
                });

                await widget.onRefresh();

                setState(() {
                  loading = false;
                });
              },
              child: "Try Again"),
        ],
      ),
    );
  }
}
