import 'dart:developer';

import 'package:bizhub/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class BizhubRunner extends StatefulWidget {
  final Widget child;

  const BizhubRunner({Key? key, required this.child}) : super(key: key);

  @override
  State<BizhubRunner> createState() => _BizhubRunnerState();

  static restartApp(BuildContext context) {
    context.findAncestorStateOfType<_BizhubRunnerState>()!.restartApp();
  }
}

class _BizhubRunnerState extends State<BizhubRunner> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}

class RestartApp extends StatefulWidget {
  final Widget child;
  const RestartApp({super.key, required this.child});

  static void restartApp(BuildContext context) {
    log(">>>>>>>>>>>>>>>>>> restarting.. <<<<<<<<<<<<<<<<<<");
    log(context.findRootAncestorStateOfType<_RestartAppState>()!.toString());
    log(">>>>>>>>>>>>>>>>>> restarting.. <<<<<<<<<<<<<<<<<<");
  }

  @override
  State<RestartApp> createState() => _RestartAppState();
}

class _RestartAppState extends State<RestartApp> {
  Key key = UniqueKey();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    Future.delayed(const Duration(seconds: 1), stopLoading);
  }

  void restartApp() {
    log("restarting..");
    setState(() {
      key = UniqueKey();
      loading = true;
    });
    Future.delayed(const Duration(seconds: 1), stopLoading);
  }

  void stopLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          backgroundColor: secondaryColor,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.loose,
              alignment: Alignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.black,
                  ),
                  child: const Text(
                    "Bizhub",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Urbanist"),
                  ),
                ),
                Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    child: const CircularProgressIndicator())
              ],
            ),
          ));
    } else {
      return KeyedSubtree(
        key: key,
        child: widget.child,
      );
    }
  }
}
