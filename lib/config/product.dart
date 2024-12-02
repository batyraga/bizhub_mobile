import 'package:flutter/material.dart';

const productGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 250.0,
    // childAspectRatio: 0.5,
    childAspectRatio: 0.655, // 0.7
    // mainAxisExtent: 260, // 250 || 230 -> 235 -> 255
    mainAxisSpacing: 15.0,
    crossAxisSpacing: 15.0); 
// const productGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
//     crossAxisCount: 2,
//     // childAspectRatio: 0.5,
//     mainAxisExtent: 260, // 250 || 230 -> 235 -> 255
//     mainAxisSpacing: 15.0,
//     crossAxisSpacing: 15.0);
