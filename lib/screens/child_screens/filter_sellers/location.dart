import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/main.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/bottom_sheet.dart';

class LocationModalBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  final List<City> cities;
  final List<String> state;
  const LocationModalBottomSheet(
      {super.key,
      required this.parentContext,
      required this.state,
      required this.cities});

  @override
  State<LocationModalBottomSheet> createState() =>
      _LocationModalBottomSheetState();
}

class _LocationModalBottomSheetState extends State<LocationModalBottomSheet> {
  // String _location = "all";
  List<String> _cities = [];
  void changeLocation(String? newValue) {
    setState(() {
      if (newValue != null) {
        _cities.add(newValue);
      } else {
        _cities.remove(newValue);
      }
    });
    Navigator.pop(widget.parentContext, _cities);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _cities = widget.state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: defaultPadding),
        child: ListView(
          shrinkWrap: true,
          children: [
            BottomSheetButton(
              icon: Icon(
                Icons.location_city,
                color: _cities.isEmpty ? primaryColor : secondaryColor,
              ),
              title: LocaleKeys.all.tr(),
              onTap: () {
                setState(() {
                  _cities = [];
                });
                Navigator.pop(widget.parentContext, _cities);
              },
            ),
            ...(widget.cities.map((city) {
              return BottomSheetButton(
                icon: Icon(
                  Icons.location_city,
                  color:
                      _cities.contains(city.id) ? primaryColor : secondaryColor,
                ),
                title: city.name,
                onTap: () {
                  changeLocation(city.id);
                },
              );
            }).toList()),
          ],
        ));
  }
}
