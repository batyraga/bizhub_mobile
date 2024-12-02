import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomizedTextField extends StatelessWidget {
  final String? label;
  final Widget? suffixIcon;
  final String? prefixText;
  final bool? enabled;
  final bool? obscureText;
  final int maxLines;
  final String? suffixText;
  final Widget? labelWidget;
  final bool? preventDefaultLabel;
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final bool asSelect;
  final int? minLines;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int? maxLength;

  const CustomizedTextField({
    super.key,
    this.onChanged,
    this.label,
    this.minLines,
    this.keyboardType,
    this.enabled,
    this.maxLength,
    this.asSelect = false,
    this.prefixText,
    this.onTap,
    this.suffixIcon,
    this.focusNode,
    this.obscureText,
    this.maxLines = 1,
    this.suffixText,
    this.labelWidget,
    this.preventDefaultLabel,
    this.controller,
    this.onSubmitted,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && preventDefaultLabel != true && labelWidget == null)
          Text(
            label!,
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                fontFamily: "Nunito"),
          ),
        if (labelWidget != null) labelWidget!,
        if (label != null || labelWidget != null)
          const SizedBox(
            height: 10,
          ),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          obscureText: obscureText != null ? true : false,
          enabled: asSelect ? false : enabled,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            prefixText: prefixText,
            suffixIcon: suffixIcon,
            counterText: "",
            suffixText: suffixText,
            prefixStyle: const TextStyle(
              color: Color.fromRGBO(151, 151, 190, 1),
              fontFamily: "Nunito",
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                    style: BorderStyle.solid),
                gapPadding: 0),
            disabledBorder: asSelect
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                        style: BorderStyle.solid),
                    gapPadding: 0)
                : null,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                    style: BorderStyle.solid),
                gapPadding: 0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                    style: BorderStyle.solid),
                gapPadding: 0),
          ),
        )
      ],
    );
  }
}

class CustomizedTextFieldLabel extends StatelessWidget {
  final String? label;
  final Widget? labelWidget;
  final bool? preventDefaultLabel;
  final Widget child;

  const CustomizedTextFieldLabel({
    Key? key,
    required this.child,
    this.label,
    this.labelWidget,
    this.preventDefaultLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label != null && preventDefaultLabel != true && labelWidget == null)
        Text(
          label!,
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              fontFamily: "Nunito"),
        ),
      if (labelWidget != null) labelWidget!,
      if (label != null || labelWidget != null)
        const SizedBox(
          height: 10,
        ),
      child,
    ]);
  }
}

class CustomizedSelectField extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final bool? disabled;
  const CustomizedSelectField({
    Key? key,
    this.disabled,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 11.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: disabled == true
                  ? const Color.fromRGBO(110, 90, 209, 0.15)
                  : const Color.fromRGBO(246, 246, 246, 1),
              border: disabled == true
                  ? Border.all(
                      color: const Color.fromRGBO(110, 90, 209, 0.15),
                    )
                  : Border.all(color: const Color.fromRGBO(229, 229, 229, 1))),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
        ));
  }
}
