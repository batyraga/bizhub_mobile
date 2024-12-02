import 'dart:developer';

import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/widgets/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/default_scroll_view.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationRoutePage extends StatefulWidget {
  final String phone;
  final BuildContext parentContext;
  final String? submitText;
  final bool? submitDanger;
  // final void Function() onSubmit;
  const VerificationRoutePage({
    super.key,
    required this.phone,
    required this.parentContext,
    this.submitDanger,
    this.submitText,
    // required this.onSubmit
  });

  @override
  State<VerificationRoutePage> createState() => _VerificationRoutePageState();
}

class _VerificationRoutePageState extends State<VerificationRoutePage> {
  bool canSubmit = false;
  bool loading = true;
  bool otpLoading = false;
  String? verificationId;
  final TextEditingController otpController = TextEditingController();
  late final countdownController = CountdownTimerController(
      endTime: DateTime.now().millisecondsSinceEpoch, onEnd: onEndCountdown);
  bool countdownActive = false;

  @override
  void initState() {
    super.initState();

    Future.wait([
      Future.sync(() {
        if (FirebaseAuth.instance.currentUser != null) {
          FirebaseAuth.instance.signOut();
        }
      }),
      sendSMSCodeToPhoneNumber(),
    ]);
  }

  void onEndCountdown() {
    log("countdown finished");
    // setState(() {
    //   countdownController=
    //   countdownActive = false;
    // });
  }

  Future<void> sendSMSCodeToPhoneNumber() async {
    setState(() {
      loading = true;
      otpLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: verificationCompleted,
      codeAutoRetrievalTimeout: (verificationId_) {
        log("[verification] - codeAutoRetrievalTimeout | verification id => $verificationId_");
        setState(() {
          verificationId = verificationId_;
        });
      },
      codeSent: (verificationId_, int? forceResendingToken) {
        log("[verification] - codeSent | verification id => $verificationId_");

        setState(() {
          verificationId = verificationId_;
          otpLoading = false;
          loading = false;
          countdownActive = true;
          countdownController.endTime = DateTime.now().millisecondsSinceEpoch +
              const Duration(minutes: 1).inMilliseconds;
          countdownController.start();
        });
      },
      timeout: const Duration(seconds: 30),
      verificationFailed: verificationFailed,
    );
  }

  void verificationCompleted(crendential) async {
    setState(() {
      otpLoading = false;
      loading = true;
    });

    log("[verification] - verificationCompeleted");
    // await showCustomAlertDialog(context,
    //     description: "Phone number authorized!");

    Future.sync(() => Navigator.pop(context, true));
  }

  void verificationFailed(FirebaseAuthException e) async {
    log("[verification] - verificationFailed");

    setState(() {
      otpLoading = false;
      loading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
  }

  Future<void> verifySMSCode() async {
    final String sms = otpController.text;

    if (verificationId == null) {
      log("[verification] - sms - verificationId == null");
      return;
    }
    if (sms.length != 6) {
      log("[verification] - sms - sms.length != 6");
      return;
    }

    setState(() {
      otpLoading = true;
    });

    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: sms);

    log("[verification] - credential - $credential");
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      return verificationCompleted(credential);
    } on FirebaseAuthException catch (err) {
      return verificationFailed(err);
    } catch (err) {
      log("[verification] - verify sms - error - $err");
    }

    setState(() {
      otpLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.verification.tr()),
      body: loading == false
          ? DefaultScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Wrap(
                  children: [
                    Text(
                      LocaleKeys.enterVerificationCodeText.tr(namedArgs: {
                        'phone': widget.phone,
                      }),
                      // "Enter 6-digit code which we have just sent to",
                      style: const TextStyle(fontSize: 17.0),
                    ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // Text(
                    //   widget.phone,
                    //   style: const TextStyle(
                    //       fontSize: 17.0, fontWeight: FontWeight.bold),
                    // )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                PinCodeTextField(
                  autoDisposeControllers: false,
                  controller: otpController,
                  appContext: context,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  length: 6,
                  autoFocus: true,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderWidth: 1.0,
                    fieldWidth:
                        (MediaQuery.of(context).size.width - (7 * 15.0)) / 6,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    errorBorderColor: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                    activeFillColor: Colors.white,
                  ),
                  // enabled: !otpLoading,
                  onCompleted: (v) {
                    log("Completed");
                    setState(() {
                      canSubmit = true;
                    });
                  },
                  onChanged: (value) {
                    log("pin code => $value");
                    setState(() {
                      canSubmit = false;
                    });
                  },
                  beforeTextPaste: (text) {
                    log("Allowing to paste $text");
                    return true;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                if (widget.submitDanger == true)
                  RedButton(
                      disabled: !canSubmit,
                      loading: otpLoading,
                      onPressed: verifySMSCode,
                      child: widget.submitText ?? LocaleKeys.submit.tr())
                else
                  PrimaryButton(
                      disabled: !canSubmit,
                      loading: otpLoading,
                      onPressed: verifySMSCode,
                      child: widget.submitText ?? LocaleKeys.submit.tr()),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CountdownTimer(
                      controller: countdownController,
                      widgetBuilder: (context, t) {
                        if (t == null) {
                          return InkWell(
                            onTap: otpLoading ? null : sendSMSCodeToPhoneNumber,
                            child: Text(
                              LocaleKeys.resendCode.tr(),
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          );
                        }
                        return Text(
                          "${t.min != null ? t.min.toString().padLeft(2, "0") : "00"}:${t.sec != null ? t.sec.toString().padLeft(2, "0") : "00"}",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                        );
                      },
                    ),
                  ],
                )
              ],
            ))
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
