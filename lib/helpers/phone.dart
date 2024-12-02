import 'dart:developer';

import 'package:bizhub/api/main.dart';

String formatPhone(String phone) {
  String str = "";
  final List<String> splitted = phone.split("");
  for (var i = 0; i < splitted.length; i++) {
    str += splitted[i];
    if (i == 1) {
      str += " ";
    }
  }

  return str;
}

Future<bool> hasPhoneOfCustomer(String phone) async {
  try {
    final bool result = await api.auth.hasPhone(phone);
    return result;
  } catch (err) {
    log("[hasPhoneOfCustomer] - error - $err");
    return false;
  }
}
