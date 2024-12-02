import 'package:flutter/material.dart';
import 'package:bizhub/providers/auth.provider.dart';
import "package:provider/provider.dart";
import 'package:bizhub/widgets/quick_login.dart';

class UseAuth extends StatelessWidget {
  final Widget child;
  const UseAuth({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<Auth>().isAuthenticated;
    debugPrint("isAuth${isAuthenticated.toString()}");
    return isAuthenticated == true ? child : const QuickLogin();
  }
}
