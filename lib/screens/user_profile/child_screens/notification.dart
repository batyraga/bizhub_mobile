import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/month_as_string.dart';
import 'package:bizhub/models/notification.model.dart';
import 'package:bizhub/providers/notification.service.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../widgets/loading.dart';

class NotificationRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const NotificationRoutePage({super.key, required this.parentContext});

  @override
  State<NotificationRoutePage> createState() => _NotificationRoutePageState();
}

class _NotificationRoutePageState extends State<NotificationRoutePage> {
  List<BizhubNotification> list = [];
  final today = DateTime.now();

  @override
  void initState() {
    super.initState();

    list = notificationService.history;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.notification.tr()),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            list = notificationService.history;
          });
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(15.0),
          itemCount: list.length,
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 15.0,
            );
          },
          itemBuilder: (context, index) {
            final n = list[index];
            return Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color.fromRGBO(235, 235, 255, 1)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${n.createdAt.hour.toString().padLeft(2, "0")}:${n.createdAt.minute.toString().padLeft(2, "0")}  -  ${n.createdAt.day.toString().padLeft(2, "0")}.${n.createdAt.month.toString().padLeft(2, "0")}.${n.createdAt.year}y",
                      style: TextStyle(
                          fontSize: 16,
                          color: (n.createdAt.day == today.day &&
                                  n.createdAt.month == today.month &&
                                  n.createdAt.year == today.year)
                              ? const Color.fromRGBO(103, 103, 103, 1)
                              : const Color.fromRGBO(251, 251, 255, 1)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      n.content,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  ]),
            );
          },
        ),
      ),
    );
  }
}
