import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ChangePasswordRoutePage extends StatefulWidget {
  final String phone;
  final BuildContext parentContext;
  const ChangePasswordRoutePage(
      {super.key, required this.phone, required this.parentContext});

  @override
  State<ChangePasswordRoutePage> createState() =>
      _ChangePasswordRoutePageState();
}

class _ChangePasswordRoutePageState extends State<ChangePasswordRoutePage> {
  final form = FormGroup({
    'new': FormControl<String>(validators: [Validators.required]),
    'new2': FormControl<String>(validators: [Validators.required]),
  }, validators: [
    Validators.mustMatch("new", "new2")
  ]);

  bool loading = false;

  Future submit() async {
    setState(() {
      loading = true;
    });
    try {
      final String newP = (form.control("new").value as String).trim();

      final bool s = await api.auth.recoverPassword(
        phone: widget.phone,
        password: newP,
      );
      if (s == true) {
        Future.sync(() => Navigator.pop(context, true));
        return;
      }
    } catch (err) {
      log("[changePasswordR] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.newPassword.tr()),
      body: ReactiveForm(
        formGroup: form,
        child: Loading(
          loading: loading,
          child: DefaultScrollView(
              child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              CustomizedTextFieldLabel(
                label: "${LocaleKeys.enterNewPassword.tr()}:",
                child: ReactiveTextField(
                  formControlName: "new",
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomizedTextFieldLabel(
                label: "${LocaleKeys.confirmNewPassword.tr()}:",
                child: ReactiveTextField(
                  formControlName: "new2",
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              SubmitButtonBuilder(builder: (context, valid) {
                return PrimaryButton(
                    disabled: !valid,
                    loading: loading,
                    onPressed: valid ? submit : null,
                    child: LocaleKeys.save.tr());
              }),
            ],
          )),
        ),
      ),
    );
  }
}
