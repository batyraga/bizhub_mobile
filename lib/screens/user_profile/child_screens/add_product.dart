import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bizhub/api/main.dart';
import 'package:bizhub/config/langs/locale_keys.g.dart';
import 'package:bizhub/models/brand.model.dart';
import 'package:bizhub/models/category.model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bizhub/models/product.model.dart';
import 'package:bizhub/providers/language.provider.dart';
import 'package:bizhub/screens/child_screens/filter_products/brands.dart';
import 'package:bizhub/screens/child_screens/filter_products/categories.dart';
import 'package:bizhub/widgets/loading.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:bizhub/config/constants.dart';
import 'package:bizhub/widgets/button.dart';
import 'package:bizhub/widgets/custom_check_box.dart';
import 'package:bizhub/widgets/default_app_bar.dart';
import 'package:bizhub/widgets/textfield_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddProductRoutePage extends StatefulWidget {
  final BuildContext parentContext;

  const AddProductRoutePage({super.key, required this.parentContext});

  @override
  State<AddProductRoutePage> createState() => _AddProductRoutePageState();
}

const imagePlaceholderColor = Color.fromRGBO(180, 180, 222, 1);

// class AddProductAttribute {
//   final String id;
//   final String value;
//   final int unitIndex;

//   const AddProductAttribute();
//   // final ProductAttribute attribute;
// }

class _AddProductRoutePageState extends State<AddProductRoutePage> {
  bool loading = false;
  UniqueKey uniqueAddProductAttributes = UniqueKey();
  final form = FormGroup({
    'heading': FormControl<String>(validators: [Validators.required]),
    'category': FormControl<MergedCategory>(validators: [Validators.required]),
    'brand': FormControl<MergedBrand>(validators: [Validators.required]),
    'attributes': FormArray<FormGroup>([]),
    'moreDetails': FormControl<String>(value: ""),
    'images': FormArray<File>([], validators: [Validators.minLength(1)]),
    'price': FormControl<double>(
        validators: [Validators.required, Validators.min(1)]),
    'iAgree':
        FormControl<bool>(value: false, validators: [Validators.requiredTrue]),
  });

  Future<void> submit() async {
    setState(() {
      loading = true;
    });

    try {
      final controls = form.controls;

      final formData = FormData.fromMap({
        'heading': controls["heading"]!.value as String,
        'more_details': controls["moreDetails"]!.value as String,
        'category_id': (controls["category"]!.value as MergedCategory).id,
        'brand_id': (controls["brand"]!.value as MergedBrand).id,
        'price': controls["price"]!.value as double,
      });

      final List<File> images =
          (controls["images"]! as FormArray<File>).value!.cast<File>();
      final List<FormGroup> attributes =
          (controls["attributes"]! as FormArray<FormGroup>)
              .value!
              .cast<FormGroup>();

      for (var i in images) {
        log("image: ${i.path}");
        final f = await MultipartFile.fromFile(i.path,
            filename: i.path.split("/").last);
        formData.files.add(MapEntry("images", f));
      }

      for (var a in attributes) {
        final v = jsonEncode({
          'attr_id': (a.controls["id"] as FormControl<String>).value!,
          'value': (a.controls["value"] as FormControl<String>).value!,
          'unit_index': (a.controls["unitIndex"] as FormControl<int>).value,
        });

        log("v: $v");

        formData.fields.add(MapEntry("attributes", v));
      }

      final String culture = await Future.sync(() => getLang(context));
      final bool status =
          await api.products.add(culture: culture, form: formData);

      if (status) {
        Future.sync(() => Navigator.pop(context, true));
        return;
      }
    } catch (err) {
      log("[addProduct] - error - $err");
      setState(() {
        loading = false;
      });
    }
  }

  void seedAttributes(List<String> l) async {
    final array = form.control("attributes") as FormArray<FormGroup>;
    List<FormGroup> gL = [];

    for (var i = 0; i < l.length; i++) {
      gL.add(FormGroup({
        'value': FormControl<String>(validators: [Validators.required]),
        'id': FormControl<String>(value: l[i]),
        'unitIndex': FormControl<int>(value: 0),
      }));
    }

    array.value = gL;
  }

  // bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: LocaleKeys.addProduct.tr()),
      body: ReactiveForm(
        formGroup: form,
        child: Loading(
          loading: loading,
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  CustomizedTextFieldLabel(
                      label: LocaleKeys.heading.tr(),
                      child: ReactiveTextField(
                        formControlName: "heading",
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomizedTextFieldLabel(
                      //* category
                      label: "${LocaleKeys.category.tr()}:",
                      child: ReactiveValueListenableBuilder<MergedCategory>(
                        formControlName: "category",
                        builder: (context, field, child) {
                          return CustomizedSelectField(
                            onTap: () async {
                              final MergedCategory? r = await Navigator.push(
                                  context,
                                  PageTransition(
                                      ctx: context,
                                      type: PageTransitionType.fade,
                                      child: CategoriesRoutePage(
                                          selected: field.value != null
                                              ? {
                                                  field.value!.parentId: [
                                                    field.value!
                                                  ],
                                                }
                                              : null,
                                          singleSelect: true,
                                          parentContext: context)));
                              if (r != null) {
                                field.value = r;
                                form.control("brand").reset();
                                setState(() {
                                  uniqueAddProductAttributes = UniqueKey();
                                });
                              }
                            },
                            title: field.value != null
                                ? field.value!.name
                                : LocaleKeys.select.tr(),
                          );
                        },
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomizedTextFieldLabel(
                      //* brand
                      label: "${LocaleKeys.brand.tr()}:",
                      child: ReactiveValueListenableBuilder<MergedBrand>(
                        formControlName: "brand",
                        builder: (context, field, child) {
                          return CustomizedSelectField(
                            onTap: () async {
                              final c = form.control("category");
                              if (c.hasErrors) {
                                return;
                              }

                              final String categoryId =
                                  (c.value as MergedCategory).id;
                              final MergedBrand? r = await Navigator.push(
                                  context,
                                  PageTransition(
                                      ctx: context,
                                      type: PageTransitionType.fade,
                                      child: BrandsRoutePage(
                                          categoryId: categoryId,
                                          selected: field.value != null
                                              ? {
                                                  field.value!.parentId: [
                                                    field.value!
                                                  ],
                                                }
                                              : null,
                                          singleSelect: true,
                                          parentContext: context)));
                              if (r != null) {
                                field.value = r;
                              }
                            },
                            title: field.value != null
                                ? field.value!.name
                                : LocaleKeys.select.tr(),
                          );
                        },
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ReactiveValueListenableBuilder<MergedCategory>(
                      formControlName: "category",
                      builder: (context, field, child) {
                        if (field.value == null) {
                          return const SizedBox();
                        }
                        return KeyedSubtree(
                          key: uniqueAddProductAttributes,
                          child: AddProductAttributes(
                              seedAttributes: seedAttributes,
                              categoryId: field.value!.id),
                        );
                      }),
                  CustomizedTextFieldLabel(
                      label: "${LocaleKeys.price.tr()}:",
                      child: ReactiveTextField(
                        formControlName: "price",
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          suffixText: "TMT",
                        ),
                        onSubmitted: (_) => form.control("moreDetails").focus(),
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  CustomizedTextFieldLabel(
                      label: "${LocaleKeys.moreDetails.tr()}:",
                      child: ReactiveTextField(
                        formControlName: "moreDetails",
                        minLines: 4,
                        maxLines: 10,
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ReactiveFormArray<File>(
                      formArrayName: "images",
                      builder: (context, formArray, child) {
                        return CustomizedTextFieldLabel(
                          label: "${LocaleKeys.photos.tr()}:",
                          child: Column(
                            children: [
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    final image = formArray.controls[i];
                                    return Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            border: Border.all(
                                                color: defaultBorderColor),
                                          ),
                                          height: 240.0,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            child: Image.file(
                                              image.value!,
                                              fit: BoxFit.cover,
                                              height: 200.0,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 10.0,
                                            right: 10.0,
                                            child: InkWell(
                                              onTap: () {
                                                formArray.removeAt(i);
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.5),
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: Colors.white,
                                                  size: 20.0,
                                                ),
                                              ),
                                            ))
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, i) {
                                    return const SizedBox(
                                      height: 15.0,
                                    );
                                  },
                                  itemCount: formArray.controls.length),
                              if (formArray.controls.isNotEmpty)
                                const SizedBox(
                                  height: 15.0,
                                ),
                              InkWell(
                                onTap: () async {
                                  form.unfocus();

                                  final images =
                                      await ImagePicker().pickMultiImage();

                                  formArray.addAll(images
                                      .map((e) => FormControl<File>(
                                          value: File(e.path)))
                                      .toList());
                                },
                                child: DottedBorder(
                                  color: imagePlaceholderColor,
                                  strokeWidth: 1,
                                  strokeCap: StrokeCap.round,
                                  borderType: BorderType.RRect,
                                  dashPattern: const [10, 10],
                                  radius: const Radius.circular(5.0),
                                  child: SizedBox(
                                    height: 200,
                                    // width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.image_outlined,
                                          size: 50,
                                          color: imagePlaceholderColor,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          LocaleKeys.addPhoto.tr(),
                                          style: const TextStyle(
                                              color: imagePlaceholderColor,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ReactiveValueListenableBuilder<bool>(
                      formControlName: "iAgree",
                      builder: (context, field, child) {
                        return InkWell(
                          onTap: () {
                            field.value = !(field.value ?? false);
                          },
                          child: Row(
                            children: [
                              CustomCheckBox(
                                checked: field.value ?? false,
                                onChange: (b) {
                                  field.value = !(field.value ?? false);
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                LocaleKeys.iAgreeWithPrivacyPolicy.tr(),
                                // "I agree with Privacy Policy",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SubmitButtonBuilder(builder: (context, valid) {
                    return PrimaryButton(
                        disabled: !valid,
                        loading: loading,
                        onPressed: valid ? submit : null,
                        child: LocaleKeys.add.tr());
                  }),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class AddProductAttributes extends StatefulWidget {
  final String categoryId;
  final void Function(List<String>) seedAttributes;
  const AddProductAttributes({
    Key? key,
    required this.categoryId,
    required this.seedAttributes,
  }) : super(key: key);

  @override
  State<AddProductAttributes> createState() => _AddProductAttributesState();
}

class _AddProductAttributesState extends State<AddProductAttributes> {
  late Future<List<CategoryAttributeDetail>> futureAttributes;

  Future<List<CategoryAttributeDetail>> loadAttributes(String culture) async {
    try {
      final result = await api.categories.getCategoryAttributes(
        categoryId: widget.categoryId,
        culture: culture,
      );

      await Future.sync(
          () => widget.seedAttributes(result.map((e) => e.id).toList()));

      return result;
    } catch (err) {
      log("[loadAttributes] - error - $err");
      return Future.error(err);
    }
  }

  @override
  void initState() {
    super.initState();

    final String culture = getLang(context);
    futureAttributes = loadAttributes(culture);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryAttributeDetail>>(
        future: futureAttributes,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            final List<CategoryAttributeDetail> list = snapshot.data!;

            return ReactiveFormArray<FormGroup>(
                formArrayName: "attributes",
                builder: (context, field, value) {
                  return ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = list[index];

                        final valueControl = field.value![index]!
                            .control("value") as FormControl<String>;

                        return CustomizedTextFieldLabel(
                          label: "${item.name}:",
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ReactiveTextField<String>(
                                keyboardType: TextInputType.number,
                                formControl: valueControl,
                                onSubmitted: (_) {
                                  if (field.value!.length == index + 1) {
                                    return;
                                  }

                                  final next = field.value![index + 1]!
                                      .control("value") as FormControl<String>;
                                  next.focus();
                                },
                              ),
                              if (item.unitsArray.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  child: ReactiveValueListenableBuilder<int>(
                                      formControl: field.value![index]!
                                              .control("unitIndex")
                                          as FormControl<int>,
                                      builder: (context, f, c) {
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton2<int>(
                                            alignment: Alignment.center,
                                            value: f.value!,
                                            onChanged: (v) {
                                              if (v != null) {
                                                f.value = v;
                                              }
                                            },
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            itemHeight: 46,
                                            buttonPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 15.0),
                                            buttonDecoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  246, 246, 246, 1),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(5.0),
                                                topRight: Radius.circular(5.0),
                                              ),
                                            ),
                                            items: item.unitsArray
                                                .asMap()
                                                .map(
                                                  (k, e) => MapEntry(
                                                      k,
                                                      DropdownMenuItem<int>(
                                                          value: k,
                                                          child: Text(e))),
                                                )
                                                .values
                                                .toList(),
                                          ),
                                        );
                                      }),
                                ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 20.0,
                        );
                      },
                      itemCount: list.length);
                });
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                height: 50.0,
                alignment: Alignment.center,
                child: const Text(
                  "failed to load attributes",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
              ),
            );
          }

          return const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: SizedBox(
              height: 50.0,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        });
  }
}
