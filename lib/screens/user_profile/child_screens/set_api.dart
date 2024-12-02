import 'package:bizhub/providers/storage.provider.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/restart_app.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:flutter/material.dart';

class SetApiRoutePage extends StatefulWidget {
  const SetApiRoutePage({Key? key}) : super(key: key);

  @override
  State<SetApiRoutePage> createState() => _SetApiRoutePageState();
}

class _SetApiRoutePageState extends State<SetApiRoutePage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final api = storage.read("api_address");
    if (api != null) {
      controller.text = api;
    }
  }

  void save() {
    final String text = controller.value.text.trim();
    if (text.isEmpty) {
      return;
    }

    storage.write("api_address", text);
    BizhubRunner.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Set Server Ip Address",
        actions: [IconButton(onPressed: save, icon: const Icon(Icons.save))],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: CustomizedTextField(
          label: "Ip Address",
          controller: controller,
        ),
      ),
    );
  }
}
