import 'dart:developer';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/api_response.model.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/child_screens/verification.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/custom_dialog.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:provider/provider.dart';

import '../../widgets/loading.dart';

class DeleteProfileRoutePage extends StatefulWidget {
  const DeleteProfileRoutePage({Key? key}) : super(key: key);

  @override
  State<DeleteProfileRoutePage> createState() => _DeleteProfileRoutePageState();
}

class _DeleteProfileRoutePageState extends State<DeleteProfileRoutePage> {
  final form = FormGroup({
    'password': FormControl<String>(validators: [Validators.required]),
  });
  bool loading = false;

  Future delete() async {
    setState(() {
      loading = true;
      form.markAsDisabled();
    });
    try {
      final bool s = await api.auth.deleteProfile();
      if (s == true) {
        Future.sync(() {
          context.read<Auth>().logout();
          BizhubRunner.restartApp(context);
        });
        return;
      } else {
        await Future.sync(() {
          showCustomAlertDialog(context,
              description: "Failed delete profile", hasError: true);
        });
        return;
      }
    } catch (err) {
      log("[deleteProfile] - error - $err");
      if (err is ApiError) {
        if (err.code == ApiErrorConstants.aborted) {
          showCustomAlertDialog(context,
              description:
                  "Wallet not empty or some transactions not completed yet",
              // "Couldn't delete your profile. Possible reasons: 1. You have money in your wallet. 2. You have money in the auction. 3. You have an incomplete transaction.",
              hasError: true);
        }
      }
    }
    setState(() {
      form.markAsEnabled();
      loading = false;
    });
  }

  Future validate() async {
    setState(() {
      loading = true;
      form.markAsDisabled();
    });

    try {
      final String password =
          (form.controls["password"]!.value as String).trim();

      final bool status = await api.auth.validatePassword(password: password);

      if (status == true) {
        final bool? s = await Future.sync(() async => await Navigator.push(
            context,
            PageTransition(
                ctx: context,
                type: PageTransitionType.fade,
                child: VerificationRoutePage(
                  phone: "+993${context.read<Auth>().currentUser!.phone}",
                  parentContext: context,
                  submitText: LocaleKeys.delete.tr(),
                  submitDanger: true,
                ))));
        if (s == true) {
          return delete();
        }
      } else {
        Future.sync(() => showCustomAlertDialog(context,
            description: "Incorrect password", hasError: true));
      }
    } catch (err) {
      log("[validateBeforeDeleteProfile] - error - $err");
    }
    setState(() {
      form.markAsEnabled();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.deleteProfile.tr(),
        onBack: loading ? () {} : null,
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Loading(
          loading: loading,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Column(
              children: [
                CustomizedTextFieldLabel(
                    label: "${LocaleKeys.enterPassword.tr()}:",
                    child: ReactiveTextField(
                      formControlName: "password",
                      obscureText: true,
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                SubmitButtonBuilder(builder: (context, valid) {
                  return PrimaryButton(
                      disabled: !valid,
                      loading: loading,
                      onPressed: valid ? validate : null,
                      child: LocaleKeys.next.tr());
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
