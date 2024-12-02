import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/api.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/helpers/validator.dart';
import 'package:bizhub/models/posts.model.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/widgets/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/widgets/ojo_form_error_boundary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/screens/user_profile/child_screens/select_related_products.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/custom_check_box.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddPostRoutePage extends StatefulWidget {
  final BuildContext parentContext;

  const AddPostRoutePage({super.key, required this.parentContext});

  @override
  State<AddPostRoutePage> createState() => _AddPostRoutePageState();
}

const imagePlaceholderColor = Color.fromRGBO(180, 180, 222, 1);

class _AddPostRoutePageState extends State<AddPostRoutePage> {
  // bool _isChecked = false;

  final form = FormGroup({
    'image': FormControl<File>(validators: [Validators.required]),
    'title': FormControl<String>(validators: [Validators.required]),
    'body': FormControl<String>(validators: [Validators.required]),
    'relatedProducts': FormArray<RelatedProductForPost>([]),
  });
  // File? image;
  // final TextEditingController heading = TextEditingController();
  // final TextEditingController description = TextEditingController();

  // List<RelatedProductForPost> relatedProducts = [];
  // final OjoFormErrorController errorController = OjoFormErrorController();
  bool loading = false;
  bool useRelatedProducts = false;

  Future<void> submit() async {
    final controls = form.controls;
    // final String headingAsString = heading.text;
    // final String descriptionAsString = description.text;

    // final validator = OjoValidatorBuilder({
    //   'image': OjoValidatorBuilder.generic<File>().required('Required image'),
    //   'heading': OjoValidatorBuilder.string().required('Required heading'),
    //   'description':
    //       OjoValidatorBuilder.string().required('Required description')
    // });
    // final validatorErrors = validator.build({
    //   'image': image,
    //   'heading': headingAsString,
    //   'description': descriptionAsString,
    // });

    // if (validatorErrors["image"]!.isNotEmpty ||
    //     validatorErrors["heading"]!.isNotEmpty ||
    //     validatorErrors["description"]!.isNotEmpty) {
    //   log('$validatorErrors');
    //   errorController.setErrors(validatorErrors);
    //   return;
    // }

    final File image = controls["image"]!.value as File;
    final String title = controls["title"]!.value as String;
    final String body = controls["body"]!.value as String;
    final List<RelatedProductForPost> relatedProducts =
        (controls["relatedProducts"]!.value as List<RelatedProductForPost?>)
            .cast<RelatedProductForPost>();

    setState(() {
      loading = true;
    });
    try {
      final xFile = XFile(image.path);
      log("image: ${xFile.path} | ${xFile.path.split("/").last} | ${xFile.mimeType}");

      final filename = xFile.path.split("/").last;
      final imageM = await MultipartFile.fromFile(
        xFile.path,
        // headers: {
        //   'Content-Type': [filename.split(".")[1]],
        // },
        // // headers:
        filename: filename,
      );

      final form = FormData.fromMap({
        'image': imageM,
        'title': title,
        'body': body,
      });

      if (relatedProducts.isNotEmpty) {
        for (var element in relatedProducts) {
          form.fields.add(MapEntry("related_products", element.id));
        }
      }

      final String culture = await Future.sync(() => getLang(context));
      final bool status = await api.posts.add(
        culture: culture,
        form: form,
      );

      if (status) {
        Future.sync(() => Navigator.pop(context, true));
        return;
      }
    } catch (err) {
      log("[addPost] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    log("culture: ${getLang(context)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(title: LocaleKeys.addPost.tr()),
        body: ReactiveForm(
          formGroup: form,
          child: Loading(
            loading: loading,
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                child: Column(
                  children: [
                    ReactiveValueListenableBuilder<File>(
                        formControlName: "image",
                        builder: (context, field, child) {
                          return Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return InkWell(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final file = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (file != null) {
                                        // setState(() {
                                        field.value = File(file.path);
                                        form.control("title").focus();
                                        // });
                                      }
                                      // errorController.clear("image");
                                    },
                                    child: field.value != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            child: Image.file(
                                              field.value!,
                                              height: constraints.maxHeight,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : DottedBorder(
                                            color: imagePlaceholderColor,
                                            strokeWidth: 1,
                                            strokeCap: StrokeCap.round,
                                            borderType: BorderType.RRect,
                                            dashPattern: const [10, 10],
                                            radius: const Radius.circular(5.0),
                                            child: SizedBox(
                                              height: constraints.maxHeight,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.image_outlined,
                                                    size: 50,
                                                    color:
                                                        imagePlaceholderColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    LocaleKeys.addPhoto.tr(),
                                                    style: const TextStyle(
                                                        color:
                                                            imagePlaceholderColor,
                                                        fontSize: 20),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                  );
                                }),
                              ),
                              if (field.hasErrors)
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 7),
                                  child: Text(
                                    "Surat saylanmadyk",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                            ],
                          );
                        }),
                    // const OjoFormError(
                    //   fieldName: "image",
                    //   margin: EdgeInsets.only(top: 10.0),
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomizedTextFieldLabel(
                        label: LocaleKeys.heading.tr(),
                        child: ReactiveTextField(
                          formControlName: "title",
                          onSubmitted: (_) => form.control("body").focus(),
                        )),
                    // CustomizedTextField(
                    //   label: "Heading: *",
                    //   controller: heading,
                    //   onChanged: (_) {
                    //     errorController.clearIfContains("heading");
                    //   },
                    // ),
                    // const OjoFormError(
                    //   fieldName: "heading",
                    //   margin: EdgeInsets.only(top: 10.0),
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomizedTextFieldLabel(
                        label: LocaleKeys.description.tr(),
                        child: ReactiveTextField(
                          formControlName: "body",
                          maxLines: 3,
                          onSubmitted: (_) => form.control("body").unfocus(),
                        )),
                    // CustomizedTextField(
                    //   label: "Description: *",
                    //   controller: description,
                    //   onChanged: (_) {
                    //     errorController.clearIfContains("description");
                    //   },
                    //   maxLines: 3,
                    // ),
                    // const OjoFormError(
                    //   fieldName: "description",
                    //   margin: EdgeInsets.only(top: 10.0),
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          useRelatedProducts = !useRelatedProducts;
                        });
                      },
                      child: Row(
                        children: [
                          CustomCheckBox(
                            checked: useRelatedProducts,
                            onChange: (v) {
                              setState(() {
                                useRelatedProducts = !useRelatedProducts;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${LocaleKeys.relatedProducts.tr()}:",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    if (useRelatedProducts)
                      const SizedBox(
                        height: 15.0,
                      ),
                    if (useRelatedProducts)
                      ReactiveFormArray<RelatedProductForPost>(
                          formArrayName: "relatedProducts",
                          builder: (context, field, value) {
                            return GridView.count(
                              crossAxisCount: 3,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              children: <Widget>[
                                ...field.value!.map((p) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      setState(() {
                                        field.value!.remove(p);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 0.15),
                                              width: 2,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: CachedNetworkImage(
                                            fit: BoxFit.fitWidth,
                                            imageUrl: "$cdnUrl${p!.image}"),
                                      ),
                                    ),
                                  );
                                }),
                                InkWell(
                                  onTap: () async {
                                    form.unfocus();
                                    final List<RelatedProductForPost>?
                                        products = await Navigator.push(
                                            context,
                                            PageTransition(
                                                ctx: context,
                                                type: PageTransitionType.fade,
                                                child: RelatedProductsRoutePage(
                                                  parentContext: context,
                                                  alreadySelectedProducts:
                                                      field.value!.cast<
                                                          RelatedProductForPost>(),
                                                )));
                                    if (products != null) {
                                      field.value = products;
                                      // setState(() {
                                      //   relatedProducts = products;
                                      // });
                                    }
                                  },
                                  child: DottedBorder(
                                    color: imagePlaceholderColor,
                                    strokeWidth: 1,
                                    strokeCap: StrokeCap.round,
                                    borderType: BorderType.RRect,
                                    dashPattern: const [10, 10],
                                    radius: const Radius.circular(5.0),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.image_outlined,
                                            size: 30,
                                            color: imagePlaceholderColor,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            LocaleKeys.addProduct.tr(),
                                            style: const TextStyle(
                                                color: imagePlaceholderColor,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ReactiveFormConsumer(builder: ((context, f, child) {
                      return PrimaryButton(
                          disabled: !f.valid,
                          onPressed: f.valid ? submit : null,
                          child: LocaleKeys.post.tr());
                    })),
                    const SizedBox(
                      height: 5.0,
                    ),
                  ],
                )),
          ),
        ));
  }
}
