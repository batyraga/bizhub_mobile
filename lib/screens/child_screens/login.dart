import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/config/pattern.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:bizhub/widgets/fade_transition_page_route.dart';
import 'package:bizhub/screens/child_screens/forgot_password.dart';
import 'package:bizhub/screens/child_screens/signup.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const LoginRoutePage({super.key, required this.parentContext});

  @override
  State<LoginRoutePage> createState() => _LoginRoutePageState();
}

class PhoneValidator extends Validator<dynamic> {
  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final error = <String, dynamic>{ValidationMessage.pattern: true};

    if (control.value is String) {
      final String p = (control.value as String).trim();

      if (p.length != 8) {
        if (p.length > 8) {
          error[ValidationMessage.maxLength] = 8;
        } else {
          error[ValidationMessage.minLength] = 8;
        }
        return error;
      }

      if (!p.startsWith("6")) {
        error[ValidationMessage.mustMatch] = 6;
        return error;
      }
    }

    return null;
  }
}

class _LoginRoutePageState extends State<LoginRoutePage> {
  // final RegExp _phoneExp = RegExp(r'^(6)[1-5][0-9]{6}');
  // final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  final form = FormGroup({
    'phone': FormControl<String>(validators: [
      Validators.required,
      Validators.pattern(phoneNumberPattern)
      // PhoneValidator().validate,
    ]),
    'password': FormControl<String>(validators: [
      Validators.required,
    ]),
  });

  void login() async {
    final String phone = (form.controls["phone"]!.value as String).trim();
    final String password = (form.controls["password"]!.value as String).trim();

    setState(() {
      form.markAsDisabled();
      loading = true;
    });

    await context.read<Auth>().login(phone, password).then((bool status) {
      if (status == true) {
        BizhubRunner.restartApp(context);
      } else {
        setState(() {
          loading = false;
          form.markAsEnabled();
        });
      }
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.login.tr(),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: DefaultScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            CustomizedTextFieldLabel(
              label: "${LocaleKeys.enterPassword.tr()}:",
              child: ReactiveTextField(
                formControlName: "phone",
                decoration: const InputDecoration(
                  prefixText: "+993  ",
                  counterText: "",
                ),
                maxLength: 8,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => form.control("password").focus(),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            CustomizedTextFieldLabel(
              labelWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${LocaleKeys.enterPassword.tr()}:",
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Nunito"),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                ctx: context,
                                type: PageTransitionType.fade,
                                child: ForgotPasswordRoutePage(
                                    parentContext: context)));
                      },
                      child: Text(
                        LocaleKeys.forgotPassword.tr(),
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(110, 90, 209, 1)),
                      ),
                    )
                  ]),
              child: ReactiveTextField(
                formControlName: "password",
                onSubmitted: (_) => form.unfocus(),
                obscureText: true,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SubmitButtonBuilder(builder: (context, valid) {
              return PrimaryButton(
                  disabled: !valid,
                  loading: loading,
                  onPressed: valid ? login : null,
                  child: LocaleKeys.login.tr());
            }),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.dontHaveAnAccount.tr(),
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            ctx: context,
                            type: PageTransitionType.fade,
                            child: SignUpRoutePage(parentContext: context)));
                  },
                  child: Text(
                    LocaleKeys.signUp.tr(),
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(110, 90, 209, 1)),
                  ),
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}
