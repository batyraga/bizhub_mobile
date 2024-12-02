import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  final bool? checked;
  final void Function(bool?)? onChange;
  const CustomCheckBox({super.key, this.checked, this.onChange});
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool _isChecked = false;

  void onChange() {
    bool v = !_isChecked;
    setState(() {
      _isChecked = v;
    });
    if (widget.onChange != null) widget.onChange!(!v);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.checked != widget.checked && widget.checked != null) {
      setState(() {
        _isChecked = widget.checked!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isChecked = widget.checked ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                  style: BorderStyle.solid)),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(3.0),
          child: AnimatedScale(
            scale: _isChecked ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )),
    );
  }
}
