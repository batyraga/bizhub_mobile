import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/config/pattern.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/child_screens/delete_profile.dart';
import 'package:bizhub/widgets/button.dart';
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

class EditProfileRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const EditProfileRoutePage({super.key, required this.parentContext});

  @override
  State<EditProfileRoutePage> createState() => _EditProfileRoutePageState();
}

class _EditProfileRoutePageState extends State<EditProfileRoutePage> {
  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'phone': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(phoneNumberPattern)
    ], disabled: true),
    'logo': FormControl<File>(validators: []),
  });

  bool loading = false;
  // File? logo;

  Future<void> editProfile() async {
    setState(() {
      loading = true;
    });

    try {
      final String name = form.controls["name"]!.value as String;
      final File? logo = form.controls["logo"]!.value as File?;

      final String newLogo = await api.auth.editProfileOfCustomer(
        name: name,
        logo: logo,
      );

      Future.sync(() {
        context.read<Auth>().changeCurrentUserName(name);
        if (logo != null) context.read<Auth>().changeCurrentUserLogo(newLogo);
        Navigator.pop(context, true);
      });
      return;
    } catch (err) {
      log("[editProfile] - error - $err");
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    form.control("name").value = context.read<Auth>().currentUser!.name;
    form.control("phone").value = context.read<Auth>().currentUser!.phone;
  }

  @override
  void dispose() {
    // nameController.dispose();
    // phoneController.dispose();
    super.dispose();
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
                  })
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
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        border: Border.all(color: Colors.grey)),
                                    child: field.value == null
                                        ? CachedNetworkImage(
                                            width: 110,
                                            height: 110,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "$cdnUrl${context.read<Auth>().currentUser?.logo}")
                                        : Image.file(
                                            field.value!,
                                            width: 110,
                                            height: 110,
                                            fit: BoxFit.cover,
                                          ),
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
