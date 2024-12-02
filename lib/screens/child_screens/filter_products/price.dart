import 'package:bizhub/helpers/numeric.dart';
import 'package:bizhub/providers/filter_product.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterPrice extends StatefulWidget {
  const FilterPrice({Key? key}) : super(key: key);

  @override
  State<FilterPrice> createState() => _FilterPriceState();
}

class _FilterPriceState extends State<FilterPrice> {
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
          onChanged: (String? newV) {
            context.read<FilterProduct>().setMin(newV != null
                ? double.tryParse(newV) != null
                    ? double.parse(newV)
                    : null
                : null);
          },
          keyboardType: TextInputType.number,
          onSubmitted: (String? newV) {
            context.read<FilterProduct>().setMin(newV != null
                ? double.tryParse(newV) != null
                    ? double.parse(newV)
                    : null
                : null);
          },
          controller: _minController,
          decoration: InputDecoration(
              suffixText: "TMT",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(7.0))),
        )),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
            child: TextField(
          keyboardType: TextInputType.number,
          onSubmitted: (String? newV) {
            context.read<FilterProduct>().setMax(newV != null
                ? double.tryParse(newV) != null
                    ? double.parse(newV)
                    : null
                : null);
          },
          onChanged: (String? newV) {
            context.read<FilterProduct>().setMax(newV != null
                ? double.tryParse(newV) != null
                    ? double.parse(newV)
                    : null
                : null);
          },
          controller: _maxController,
          decoration: InputDecoration(
              suffixText: "TMT",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              enabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(7.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(7.0))),
        )),
      ],
    );
  }
}
