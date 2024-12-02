import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class OjoFormErrorController with ChangeNotifier {
  Map<String, Map<String, String>> errors = {};

  Map<String, String>? get(String n) {
    return errors[n];
  }

  String? getByType(String n, String t) {
    return get(n)?[t];
  }

  set(String n, Map<String, String> errors_) {
    errors[n] = errors_;
    notifyListeners();
  }

  setErrors(Map<String, Map<String, String>> errors_) {
    errors = errors_;
    notifyListeners();
  }

  setError(String n, String t, String error) {
    if (errors.containsKey(n)) {
      errors[n]![t] = error;
      notifyListeners();
    } else {
      set(n, {
        t: error,
      });
    }
  }

  clearIfContains(String n) {
    if (errors.containsKey(n)) {
      return clear(n);
    }
  }

  clear(String n) {
    errors.remove(n);
    notifyListeners();
  }

  clearAll() {
    errors.clear();
    notifyListeners();
  }
}

class OjoFormErrorBoundary extends StatefulWidget {
  final Widget child;
  final OjoFormErrorController controller;
  const OjoFormErrorBoundary({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  State<OjoFormErrorBoundary> createState() => _OjoFormErrorBoundaryState();
}

class _OjoFormErrorBoundaryState extends State<OjoFormErrorBoundary> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => widget.controller,
      child: widget.child,
    );
  }
}

class OjoFormError extends StatefulWidget {
  final String fieldName;
  final String? type;
  final EdgeInsetsGeometry? margin;
  const OjoFormError({
    Key? key,
    required this.fieldName,
    this.margin,
    this.type,
  }) : super(key: key);

  @override
  State<OjoFormError> createState() => _OjoFormErrorState();
}

class _OjoFormErrorState extends State<OjoFormError> {
  List<String> getErrors(OjoFormErrorController c) {
    if (widget.type == null) {
      final a = c.get(widget.fieldName);
      if (a != null) {
        return a.values.toList();
      }
      return [];
    } else {
      final a = c.getByType(widget.fieldName, widget.type!);
      if (a != null) {
        return [a];
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OjoFormErrorController>();
    final List<String> errors = getErrors(controller);
    if (errors.isEmpty) {
      return const SizedBox();
    } else {
      return Container(
        margin: widget.margin,
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color.fromRGBO(255, 0, 0, 0.15),
        ),
        child: Wrap(
          runSpacing: 5.0,
          direction: Axis.vertical,
          children: errors
              .map((e) => Text(
                    e,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Color.fromRGBO(255, 0, 0, 1),
                    ),
                  ))
              .toList(),
        ),
      );
    }
  }
}
