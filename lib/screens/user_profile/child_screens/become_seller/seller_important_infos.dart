import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/main.dart';
import 'package:bizhub/widgets/city_selector.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';

class SellerImportantInfosTab extends StatefulWidget {
  const SellerImportantInfosTab({super.key});

  @override
  State<SellerImportantInfosTab> createState() =>
      _SellerImportantInfosTabState();
}

class _SellerImportantInfosTabState extends State<SellerImportantInfosTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${LocaleKeys.selectCity.tr()}:",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ReactiveValueListenableBuilder<City>(
                formControlName: "city",
                builder: (context, field, child) {
                  return CustomizedSelectField(
                      onTap: () async {
                        final r = await selectCity(context,
                            selected: field.value?.id);

                        if (r != null) {
                          field.value = City(id: r.id, name: r.name);
                        }
                      },
                      title: field.value != null
                          ? field.value!.name
                          : LocaleKeys.selectCity.tr());
                },
              ),
              // GestureDetector(
              //     onTap: () async {
              //       final selected =
              //           await selectCity(context, selected: city?.id);
              //       if (selected != null) {
              //         setState(() {
              //           city = selected;
              //           _cityController.text =
              //               city?.name ?? "Not Selected City";
              //           widget.controller.setCity(selected);
              //         });
              //       }
              //     },
              //     child: CustomizedTextField(
              //       asSelect: true,
              //       controller: _cityController,
              //     ))
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${LocaleKeys.enterFullAddress.tr()}:",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ReactiveTextField(
                formControlName: "address",
                keyboardType: TextInputType.streetAddress,
                minLines: 3,
                maxLines: 4,
              )
            ],
          ),
        ],
      ),
    );
  }
}
