import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/pattern.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/screens/child_screens/delete_profile.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/city_selector.dart';
import 'package:bizhub/widgets/loading.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/screens/user_profile/child_screens/change_password.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SellerForEditProfile {
  final String name;
  final String logo;
  final City city;
  final String address;
  final String bio;
  final String phone;
  const SellerForEditProfile({
    required this.address,
    required this.bio,
    required this.city,
    required this.logo,
    required this.name,
    required this.phone,
  });
}

class EditSellerProfileRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final SellerForEditProfile defaultSellerInfo;
  const EditSellerProfileRoutePage(
      {super.key,
      required this.defaultSellerInfo,
      required this.parentContext});

  @override
  State<EditSellerProfileRoutePage> createState() =>
      _EditSellerProfileRoutePageState();
}

class _EditSellerProfileRoutePageState
    extends State<EditSellerProfileRoutePage> {
  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'phone': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(phoneNumberPattern)
    ], disabled: true),
    'logo': FormControl<File>(validators: []),
    'city': FormControl<City>(validators: [Validators.required]),
    'address': FormControl<String>(validators: [Validators.required]),
    'bio': FormControl<String>(validators: [Validators.required]),
  });

  bool loading = false;
  // File? logo;

  Future<void> editProfile() async {
    setState(() {
      loading = true;
      form.markAsDisabled();
    });

    try {
      final String name = form.controls["name"]!.value as String;
      final File? logo = form.controls["logo"]!.value as File?;
      final City city = form.controls["city"]!.value as City;
      final String address = (form.controls["address"]!.value as String).trim();
      final String bio = (form.controls["bio"]!.value as String).trim();

      final String culture = getLang(context);

      final bool st = await api.auth.editProfileOfSeller(
        name: name,
        logo: logo,
        city: city,
        address: address,
        bio: bio,
        culture: culture,
      );

      if (st) {
        Future.sync(() {
          // context.read<Auth>().changeCurrentUserName(name);
          // if (logo != null) context.read<Auth>().changeCurrentUserLogo(newLogo);
          Navigator.pop(context, true);
        });
        return;
      }
    } catch (err) {
      log("[editProfile] - error - $err");
    }

    setState(() {
      loading = false;
      form.markAsEnabled();
    });
  }

  @override
  void initState() {
    super.initState();
    form.control("name").value = widget.defaultSellerInfo.name;
    form.control("phone").value = widget.defaultSellerInfo.phone;
    form.control("city").value = widget.defaultSellerInfo.city;
    form.control("address").value = widget.defaultSellerInfo.address;
    form.control("bio").value = widget.defaultSellerInfo.bio;
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: form,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: LocaleKeys.editProfile.tr(),
          actions: loading
              ? null
              : [
                  SubmitButtonBuilder(builder: (context, valid) {
                    return IconButton(
                        onPressed: valid ? editProfile : null,
                        icon: Icon(
                          Icons.check,
                          color: valid
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                        ));
                  }),
                ],
        ),
        body: Loading(
          loading: loading,
          child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: defaultPadding,
                  right: defaultPadding,
                  bottom: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReactiveValueListenableBuilder<File>(
                      formControlName: "logo",
                      builder: (context, field, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 55.0,
                                    backgroundColor: Colors.red,
                                    foregroundImage: field.value == null
                                        ? CachedNetworkImageProvider(
                                            "$cdnUrl${widget.defaultSellerInfo.logo}",
                                          )
                                        : Image.file(
                                            field.value!,
                                          ).image,
                                  ),
                                  Positioned(
                                    bottom: 1,
                                    right: 1,
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      onTap: () async {
                                        final picker = ImagePicker();
                                        final file = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        if (file != null) {
                                          field.value = File(file.path);
                                          form.control("name").focus();
                                        }
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                                style: BorderStyle.solid)),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          size: 18,
                                          color: Color.fromARGB(
                                              255, 110, 110, 110),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 15.0,
                  ),
                  CustomizedTextFieldLabel(
                      label: "${LocaleKeys.name.tr()}:",
                      child: ReactiveTextField(
                        formControlName: "name",
                        onSubmitted: (_) => form.control("address").focus(),
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  CustomizedTextFieldLabel(
                      label: "${LocaleKeys.city.tr()}:",
                      child: ReactiveValueListenableBuilder<City>(
                        formControlName: "city",
                        builder: (context, field, child) {
                          return CustomizedSelectField(
                              onTap: () async {
                                final r = await selectCity(context,
                                    selected: field.value!.id);

                                if (r != null) {
                                  field.value = City(id: r.id, name: r.name);
                                }
                              },
                              title: field.value!.name);
                        },
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  CustomizedTextFieldLabel(
                      label: "${LocaleKeys.address.tr()}:",
                      child: ReactiveTextField(
                        maxLines: 4,
                        minLines: 1,
                        formControlName: "address",
                        onSubmitted: (_) => form.control("bio").focus(),
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  CustomizedTextFieldLabel(
                      label: "${LocaleKeys.moreInfo.tr()}:",
                      child: ReactiveTextField(
                        maxLines: 5,
                        minLines: 3,
                        formControlName: "bio",
                        onSubmitted: (_) => form.unfocus(),
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  CustomizedTextFieldLabel(
                      label: "${LocaleKeys.phoneNumber.tr()}:",
                      child: ReactiveTextField(
                        formControlName: "phone",
                        decoration: const InputDecoration(
                          prefixText: "+993  ",
                          enabled: false,
                          counterText: "",
                          suffixIcon: Icon(Icons.lock_outline_rounded),
                        ),
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    ctx: context,
                                    type: PageTransitionType.fade,
                                    child: ChangePasswordRoutePage(
                                        parentContext: context)));
                          },
                          child: const Text(
                            LocaleKeys.changePassword,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).tr()),
                      TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    ctx: context,
                                    type: PageTransitionType.fade,
                                    child: const DeleteProfileRoutePage()));
                          },
                          child: const Text(
                            LocaleKeys.deleteProfile,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).tr()),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
