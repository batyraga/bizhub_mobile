import 'package:flutter/material.dart';

const defaultBorderRadius = 5.0;
const defaultPadding = 15.0;
const defaultBorderColor = Color.fromRGBO(229, 229, 229, 1);
const defaultPrimaryText = Color.fromRGBO(104, 104, 149, 1);
const defaultPrimaryBackgroundColor = Color.fromRGBO(64, 64, 124, 1);

const primaryColor = Color.fromRGBO(110, 90, 209, 1);
const secondaryColor = Color.fromARGB(255, 255, 199, 0);

OutlineInputBorder textFieldBorder(BuildContext context) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 1,
        style: BorderStyle.solid),
    gapPadding: 0);

const shimmerBaseColor = Color.fromRGBO(245, 245, 245, 1);
const shimmerHighlightColor = Color.fromRGBO(222, 222, 222, 1);
