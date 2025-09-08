import 'dart:developer';
import 'dart:isolate';
import 'dart:math' as math;

import 'package:bizhub/api/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/providers/events.provider.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

class BizhubFetchErrors extends StatefulWidget {
  final Widget child;
  const BizhubFetchErrors({Key? key, required this.child}) : super(key: key);

  @override
  State<BizhubFetchErrors> createState() => _BizhubFetchErrorsState();

  static error() {
    globalEvents.emit("check-connection");
  }

  static errorCheck(BuildContext context) {
    context.findAncestorStateOfType<_BizhubFetchErrorsState>()?.onError();
  }
}

class _BizhubFetchErrorsState extends State<BizhubFetchErrors> {
  bool show = false;
  bool isConnectedInternet = true;
  bool isServerError = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen(onChangeConnectivity);
  }

  void onChangeConnectivity(List<ConnectivityResult> results) {
    // Check if there is no connectivity in the results list
    if (results.contains(ConnectivityResult.none)) {
      if (!show) {
        setState(() {
          show = true;
          isConnectedInternet = false;
        });
      }
    }
    // else {
    //   // Handle reconnection if needed
    //   if (show) {
    //     setState(() {
    //       show = false;
    //       isConnectedInternet = true;
    //     });
    //   }
    // }
  }

  // onChangeConnectivity(ConnectivityResult r) {
  //   if (r == ConnectivityResult.none) {
  //     if (!show) {
  //       setState(() {
  //         show = true;
  //         isConnectedInternet = false;
  //       });
  //     }
  //   }
  // }

  void onError() {
    if (!show) {
      setState(() {
        show = true;
        isServerError = true;
      });
    }
  }

  Future<void> checkServerConnection() async {
    try {
      final bool s = await api.auth.checkServerConnection();

      if (s == true) {
        Future.sync(() => BizhubRunner.restartApp(context));
        return;
      }
    } catch (err) {
      log("[checkServerConnection] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  Future tryAgain() async {
    if (isServerError) {
      await checkServerConnection();
    } else {
      if (isConnectedInternet) {
        BizhubRunner.restartApp(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: show ? 1 : 0,
      children: [
        widget.child,
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xffF7F8FA), Color(0xffE5EBF4)],
                        stops: [0.0, 1.0],
                        transform: GradientRotation(math.pi / 4))),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          fit: BoxFit.fill,
                          width: 250.0,
                          height: 250.0,
                          image: AssetImage("assets/images/khaby.png"),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Column(
                          children: [
                            const Text(
                              LocaleKeys.oops,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30.0,
                              ),
                            ).tr(),
                            const SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                isServerError
                                    ? "Server error"
                                    : LocaleKeys.noInternetConnection.tr(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(110, 117, 123, 1)),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                    PrimaryButton(
                        onPressed: tryAgain,
                        disabled: !isConnectedInternet,
                        loading: loading,
                        child: LocaleKeys.tryAgain.tr())
                  ],
                ),
              ),
              if (loading)
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      color: const Color.fromARGB(255, 255, 247, 0),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const CircularProgressIndicator(),
                    )),
            ],
          ),
        )
      ],
    );
  }
}
