import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ChangePasswordRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const ChangePasswordRoutePage({super.key, required this.parentContext});

  @override
  State<ChangePasswordRoutePage> createState() =>
      _ChangePasswordRoutePageState();
}

class _ChangePasswordRoutePageState extends State<ChangePasswordRoutePage> {
  final form = FormGroup({
    'old': FormControl<String>(validators: [Validators.required]),
    'new': FormControl<String>(validators: [Validators.required]),
    'new2': FormControl<String>(validators: [Validators.required]),
  }, validators: [
    Validators.mustMatch("new", "new2")
  ]);

  // final TextEditingController currentPasswordController =
  //     TextEditingController();
  // final TextEditingController newPasswordController = TextEditingController();
  // final TextEditingController confirmNewPasswordController =
  //     TextEditingController();

  bool loading = false;

  Future<void> changePassword() async {
    setState(() {
      loading = true;
      form.markAsDisabled();
    });
    try {
      final currentPassword = (form.controls["old"]!.value as String).trim();
      final newPassword = (form.controls["new"]!.value as String).trim();

      final bool status = await api.auth.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);

      if (status == true) {
        Future.sync(() {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Successfuly changed password!")));
          Navigator.pop(context, true);
        });
        return;
      }

      throw Exception("failed change user password");
    } catch (err) {
      log("[changePassword] - error - $err");

      if (err is ApiError) {
        log(err.code);
        if (err.code == ApiErrorConstants.inSecurePassword) {
          form.control("new2").setErrors({
            ValidationMessage.any: "in secure password",
          });
        }
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$err")));
    }
    setState(() {
      form.markAsEnabled();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.changePassword.tr()),
      body: ReactiveForm(
        formGroup: form,
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomizedTextFieldLabel(
                  label: "${LocaleKeys.enterPassword.tr()}:",
                  child: ReactiveTextField(
                    formControlName: "old",
                    obscureText: true,
                    onSubmitted: (_) => form.control("new").focus(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomizedTextFieldLabel(
                  label: "${LocaleKeys.newPassword.tr()}:",
                  child: ReactiveTextField(
                    formControlName: "new",
                    obscureText: true,
                    onSubmitted: (_) => form.control("new2").focus(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomizedTextFieldLabel(
                  label: "${LocaleKeys.confirmNewPassword.tr()}:",
                  child: ReactiveTextField(
                    formControlName: "new2",
                    obscureText: true,
                    onSubmitted: (_) => form.unfocus(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SubmitButtonBuilder(builder: (context, valid) {
                  return PrimaryButton(
                      disabled: !valid,
                      onPressed: valid ? changePassword : null,
                      loading: loading,
                      child: LocaleKeys.save.tr());
                })
              ],
            )),
      ),
    );
  }
}
