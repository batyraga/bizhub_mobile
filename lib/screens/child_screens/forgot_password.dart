import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/pattern.dart';
import 'package:bizhub/helpers/phone.dart';
import 'package:bizhub/widgets/custom_dialog.dart';
import 'package:bizhub/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/screens/child_screens/change_password.dart';
import 'package:bizhub/screens/child_screens/verification.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ForgotPasswordRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const ForgotPasswordRoutePage({super.key, required this.parentContext});

  @override
  State<ForgotPasswordRoutePage> createState() =>
      _ForgotPasswordRoutePageState();
}

class _ForgotPasswordRoutePageState extends State<ForgotPasswordRoutePage> {
  final form = FormGroup({
    'phone': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(phoneNumberPattern)
    ]),
  });

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.recoverPassword.tr(),
      ),
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
                label: "${LocaleKeys.enterPassword}:",
                child: ReactiveTextField(
                  formControlName: "phone",
                  decoration: const InputDecoration(
                    prefixText: "+993  ",
                    counterText: "",
                  ),
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => form.unfocus(),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              SubmitButtonBuilder(builder: (context, valid) {
                return PrimaryButton(
                    onPressed: valid
                        ? () async {
                            setState(() {
                              loading = true;
                            });
                            final String phone =
                                form.control("phone").value as String;

                            final bool isValidPhone =
                                await hasPhoneOfCustomer(phone);
                            if (isValidPhone == false) {
                              setState(() {
                                loading = false;
                              });

                              Future.sync(() => showCustomAlertDialog(context,
                                  description: "This phone is invalid"));
                              return;
                            }

                            final bool? s =
                                await Future.sync(() => Navigator.push(
                                    context,
                                    PageTransition(
                                        ctx: context,
                                        type: PageTransitionType.fade,
                                        child: VerificationRoutePage(
                                          phone: "+993$phone",
                                          parentContext: context,
                                        ))));

                            if (s == true) {
                              final bool? c = await Future.sync(() async =>
                                  await Navigator.push(
                                      context,
                                      PageTransition(
                                          ctx: context,
                                          type: PageTransitionType.fade,
                                          child: ChangePasswordRoutePage(
                                              phone: phone,
                                              parentContext: context))));

                              if (c == true) {
                                Future.sync(() {
                                  showCustomAlertDialog(context,
                                      description:
                                          "Successfuly changed password!");
                                  Navigator.pop(context);
                                });
                              }
                            }

                            setState(() {
                              loading = false;
                            });
                          }
                        : null,
                    disabled: !valid,
                    child: LocaleKeys.getVerificationCode.tr());
              }),
            ],
          )),
        ),
      ),
    );
  }
}
