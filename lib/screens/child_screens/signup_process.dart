import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/user.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/widgets/custom_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SignupProcessRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  final String phoneNumber;
  const SignupProcessRoutePage(
      {super.key, required this.phoneNumber, required this.parentContext});

  @override
  State<SignupProcessRoutePage> createState() => _SignupProcessRoutePageState();
}

class _SignupProcessRoutePageState extends State<SignupProcessRoutePage> {
  late final TextEditingController _phoneFieldController =
      TextEditingController(text: widget.phoneNumber);
  bool loading = false;
  final formGroup = FormGroup({
    'avatar': FormControl<File>(),
    'name': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)]),
    'confirmPassword': FormControl<String>(validators: [Validators.required]),
  }, validators: [
    Validators.compare("confirmPassword", "password", CompareOption.equal)
  ]);

  Future submit() async {
    formGroup.unfocus();
    try {
      final controls = formGroup.controls;

      final formData = FormData.fromMap({
        'name': controls["name"]!.value as String,
        'password': controls["password"]!.value as String,
        'phone': widget.phoneNumber,
      });

      if (controls["avatar"]!.value != null) {
        final String aP = (controls["avatar"]!.value as File).path;

        final avatar = await MultipartFile.fromFile(
          aP,
          filename: aP.split("/").last,
        );

        formData.files.add(MapEntry("logo", avatar));
      }

      final Map<String, dynamic> result = await api.auth.signUp(formData);

      log("${result["user"]} $result");

      final String accessToken = result["access_token"] as String;
      final String refreshToken = result["refresh_token"] as String;
      final User user = User.fromJson(result["user"] as Map<String, dynamic>);

      final authProvider = await Future.sync(() => context.read<Auth>());
      final ss = await authProvider.signUp(user, accessToken, refreshToken);
      if (ss == true) {
        Future.sync(() => BizhubRunner.restartApp(context));
        return;
      } else {
        throw Exception("failed to save user info");
      }
    } catch (err) {
      log("err type: ${err.runtimeType}");
      if (err is DioError) {
        if (err.response?.data is Map<String, dynamic>) {
          final code = err.response?.data["error"]["code"];
          log("code: $code");
          if (code is String) {
            if (code == ApiErrorConstants.notAllowed) {
              showCustomAlertDialog(context,
                  description: "Sizin telefon belginiz ulgama on girizilen",
                  hasError: true);
            }
          }
        }
      }

      log("[signUp] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.enterInformation.tr()),
      body: ReactiveForm(
        formGroup: formGroup,
        child: SingleChildScrollView(
            padding: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                bottom: defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveValueListenableBuilder<File>(
                    formControlName: 'avatar',
                    builder: (context, field, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 230, 230, 230)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: field.value != null
                                        ? Image.file(
                                            field.value!,
                                            fit: BoxFit.cover,
                                            width: 110,
                                            height: 110,
                                          )
                                        : const Image(
                                            width: 110,
                                            fit: BoxFit.cover,
                                            height: 110,
                                            image: AssetImage(
                                                "assets/images/profile.png")),
                                  ),
                                ),
                                Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100.0),
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final file = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (file != null) {
                                        field.value = File(file.path);
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
                                        color:
                                            Color.fromARGB(255, 110, 110, 110),
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
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                CustomizedTextFieldLabel(
                  label: "${LocaleKeys.createPassword.tr()}:",
                  child: ReactiveTextField(
                    obscureText: true,
                    formControlName: "password",
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                CustomizedTextFieldLabel(
                  label: "${LocaleKeys.confirmPassword.tr()}:",
                  child: ReactiveTextField(
                    formControlName: "confirmPassword",
                    obscureText: true,
                    validationMessages: {
                      'compare': (e) => "Den edey \\:)",
                    },
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                CustomizedTextField(
                  label: "${LocaleKeys.phoneNumber.tr()}:",
                  prefixText: "+993   ",
                  enabled: false,
                  controller: _phoneFieldController,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SubmitButtonBuilder(
                    builder: (context, valid) => PrimaryButton(
                        disabled: !valid,
                        onPressed: valid ? submit : null,
                        child: LocaleKeys.signUp.tr()))
              ],
            )),
      ),
    );
  }
}
