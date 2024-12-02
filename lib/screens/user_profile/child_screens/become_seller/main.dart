import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/city.model.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/widgets/city_selector.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/providers/auth.provider.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/seller_logo.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/seller_name.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/seller_optional_infos.dart';
import 'package:bizhub/screens/user_profile/child_screens/become_seller/seller_important_infos.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/next_and_prev.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BecomeSellerControllerResult {
  final String name;
  final File logo;
  final String cityId;
  final String address;
  final String bio;

  const BecomeSellerControllerResult(
      {required this.address,
      required this.bio,
      required this.cityId,
      required this.logo,
      required this.name});
}

class BecomeSellerController extends ChangeNotifier {
  String name = "";
  File? logo;
  CitySelectorResult? city;
  String address = "";
  String bio = "";

  void setName(String newName) {
    name = newName;
    log("[BecomeSellerController] - name - $name");
    notifyListeners();
  }

  void setLogo(File logo_) {
    logo = logo_;
    log("[BecomeSellerController] - logo - ${logo?.path}");
    notifyListeners();
  }

  void setCity(CitySelectorResult city_) {
    city = city_;
    log("[BecomeSellerController] - city - ${city?.name}");
    notifyListeners();
  }

  void setAddress(String addr) {
    address = addr;
    log("[BecomeSellerController] - address - $address");
    notifyListeners();
  }

  void setBio(String b) {
    bio = b;
    log("[BecomeSellerController] - bio - $bio");
    notifyListeners();
  }

  bool canFinish() {
    if (name.trim().isEmpty) {
      return false;
    }
    if (address.trim().isEmpty) {
      return false;
    }
    if (city == null) {
      return false;
    }
    if (logo == null) {
      return false;
    }

    return true;
  }

  BecomeSellerControllerResult? prepareData() {
    if (!canFinish()) {
      return null;
    }

    final String address_ = address.trim();
    final String bio_ = bio.trim();
    final String cityId_ = city!.id;
    final File logo_ = logo!;
    final String name_ = name.trim();

    return BecomeSellerControllerResult(
      address: address_,
      bio: bio_,
      cityId: cityId_,
      logo: logo_,
      name: name_,
    );
  }
}

class BecomeSellerRoutePage extends StatefulWidget {
  final BuildContext parentContext;
  const BecomeSellerRoutePage({super.key, required this.parentContext});

  @override
  State<BecomeSellerRoutePage> createState() => _BecomeSellerRoutePageState();
}

class _BecomeSellerRoutePageState extends State<BecomeSellerRoutePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final TabController _tabController;
  bool loading = false;
  double sendingProgress = 0.0;
  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'logo': FormControl<File>(validators: [Validators.required]),
    'city': FormControl<City>(validators: [Validators.required]),
    'address': FormControl<String>(validators: [Validators.required]),
    'bio': FormControl<String>(validators: [Validators.required]),
  });

  Future<void> onFinish() async {
    if (form.invalid) {
      return;
    }

    form.unfocus();

    setState(() {
      loading = true;
    });

    try {
      final controls = form.controls;

      final String name = (controls["name"]!.value as String).trim();
      final File logo = controls["logo"]!.value as File;
      final City city = controls["city"]!.value as City;
      final String bio = (controls["bio"]!.value as String).trim();
      final String address = (controls["address"]!.value as String).trim();

      final result = await api.auth.becomeSeller(
        (r, t) {
          setState(() {
            sendingProgress = r / t * 100;
          });
        },
        context,
        name: name,
        culture: getLang(context),
        logo: logo,
        cityId: city.id,
        bio: bio,
        address: address,
      );

      Future.sync(() => context.read<Auth>().changeStatusAsSeller(result));

      log("[BecomeSeller] - onFinish - completed!");

      Future.sync(() => Navigator.pop(context));
    } catch (err) {
      log("[BecomeSeller] - onFinish - err - $err");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$err")));
    }

    setState(() {
      loading = false;
    });
    // context.read<Auth>().changeSellerStatus();
    // Navigator.pop(widget.parentContext);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    debugPrint("default index => ${_tabController.index}");
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: LocaleKeys.becomeSeller.tr(),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: loading == true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "${sendingProgress.toStringAsFixed(2)} %",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16.0),
                    )
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: const [
                      SellerNameTab(),
                      SellerLogoTab(),
                      SellerImportantInfosTab(),
                      SellerOptionalInfosTab(),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment:
                          (_currentIndex > 0 && _currentIndex != 3)
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                      children: [
                        if (_currentIndex > 0 && _currentIndex != 3)
                          PrevButton(
                              onTap: () {
                                if (0 == _tabController.length) {
                                  _tabController
                                      .animateTo(_tabController.length - 1);
                                } else {
                                  _tabController
                                      .animateTo(_tabController.index - 1);
                                }
                              },
                              title: "Prev"),
                        NextButton(
                            onTap: ((_currentIndex < _tabController.length - 1)
                                ? () {
                                    final name = form.control("name");
                                    final city = form.control("city");
                                    final bio = form.control("bio");
                                    final address = form.control("address");
                                    final logo = form.control("logo");

                                    switch (_tabController.index) {
                                      case 0:
                                        if (name.hasErrors) {
                                          return;
                                        }
                                        name.unfocus();
                                        logo.focus();
                                        break;
                                      case 1:
                                        if (form.control("logo").hasErrors) {
                                          return;
                                        }
                                        logo.unfocus();
                                        city.focus();
                                        break;
                                      case 2:
                                        if (form.control("city").hasErrors ||
                                            form.control("address").hasErrors) {
                                          return;
                                        }
                                        city.unfocus();
                                        address.unfocus();
                                        bio.focus();
                                        break;
                                      case 3:
                                        if (form.control("bio").hasErrors) {
                                          return;
                                        }
                                        form.unfocus();
                                        break;
                                      default:
                                        break;
                                    }

                                    if (_tabController.index ==
                                        _tabController.length - 1) {
                                      return;
                                    }
                                    if (_tabController.index - 1 ==
                                        _tabController.length) {
                                      _tabController.animateTo(0);
                                    } else {
                                      _tabController
                                          .animateTo(_tabController.index + 1);
                                    }
                                  }
                                : onFinish),
                            title: (_currentIndex < _tabController.length - 1)
                                ? LocaleKeys.next.tr()
                                : "Finish")
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
