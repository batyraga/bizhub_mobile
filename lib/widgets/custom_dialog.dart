import 'package:bizhub/widgets/button.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String description;
  final bool hasError;
  final Widget Function(BuildContext context)? toolsBuilder;
  const CustomAlertDialog(
      {super.key,
      required this.description,
      this.hasError = false,
      this.toolsBuilder});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      contentPadding: const EdgeInsets.all(20.0),
      children: [
        Text(
          description,
          style: const TextStyle(
              fontSize: 19, color: Color.fromRGBO(85, 85, 85, 1)),
        ),
        const SizedBox(
          height: 20.0,
        ),
        if (toolsBuilder != null)
          toolsBuilder!(context)
        else
          (hasError == true
              ? RedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: "OK")
              : PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: "OK"))
      ],
    );
  }
}

Future<T?> showCustomAlertDialog<T>(
  BuildContext context, {
  required String description,
  bool hasError = false,
  Widget Function(BuildContext context)? toolsBuilder,
}) async {
  return await showDialog<T>(
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
            description: description,
            toolsBuilder: toolsBuilder,
            hasError: hasError,
          ));
}

Future<bool> showConfirmDialog(BuildContext context, String description) async {
  return await showCustomAlertDialog<bool?>(
        context,
        description: description,
        toolsBuilder: (context) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SecondaryButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: "Cancel"),
            ),
            const SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: "Ok"),
            ),
          ],
        ),
      ) ==
      true;
}
