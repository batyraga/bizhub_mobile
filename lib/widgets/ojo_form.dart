// import 'package:flutter/material.dart';

// typedef OjoFormFieldValidator<T> = String? Function(T? value);

// class OjoFormFieldValue<T> {
//   final String name;
//   T? value;
//   final List<OjoFormFieldValidator<T>> validators = [];
//   OjoFormFieldValue(this.name, this.value);

//   OjoFormFieldError? validate() {
//     for (var element in validators) {
//       final errString = element.call(value);
//       if (errString != null) {
//         return OjoFormFieldError(name, errString);
//       }
//     }
//     return null;
//   }
// }

// class OjoFormFieldError {
//   final String name;
//   final String error;
//   const OjoFormFieldError(this.name, this.error);
// }

// class OjoFormController with ChangeNotifier {
//   Map<String, OjoFormFieldValue> fields = {};
//   Map<String, OjoFormFieldError?> errors = {};

//   void register(String name, OjoFormFieldValue value) {
//     fields[name] = value;
//     notifyListeners();
//   }

//   Map<String, OjoFormFieldValue>? submit() {
//     Map<String, OjoFormFieldError?> errors_ = {};
//     fields.forEach((key, value) {
//       final OjoFormFieldError? err = value.validate();
//       if (err != null) {
//         errors_[key] = err;
//       }
//     });

//     if (errors_.isNotEmpty) {
//       errors = errors_;
//       notifyListeners();
//       return null;
//     }

//     return fields;
//   }
// }

// class OjoForm extends StatefulWidget {
//   final Widget child;
//   final OjoFormController controller;
//   const OjoForm({
//     super.key,
//     required this.child,
//     required this.controller,
//   });

//   @override
//   State<OjoForm> createState() => _OjoFormState();
// }

// class _OjoFormState extends State<OjoForm> {
//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }

// class OjoFormField extends StatefulWidget {
//   final Widget Function(BuildContext context, OjoFormFieldValue value) builder;
//   const OjoFormField({
//     super.key,
//     required this.builder,
//   });

//   @override
//   State<OjoFormField> createState() => _OjoFormFieldState();
// }

// class _OjoFormFieldState extends State<OjoFormField> {
//   late OjoFormController controller;
//   late 

//   @override
//   void initState() {
//     super.initState();

//     final state = context.findAncestorStateOfType<_OjoFormState>();
//     if (state != null) {
//       controller = state.widget.controller;
//     } else {
//       throw FlutterError("not found ojo form controller for field");
//     }
//   }

//   // final value =
//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(
//       context,
//     );
//   }
// }
