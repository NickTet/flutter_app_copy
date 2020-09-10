


import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageHelper{
  static const String baseImgUrl = "";


  static String wrapAssets(String url){
    return "assets/images/"+url;
  }


  static Widget placeHolder({double width,double height}){
    return SizedBox(
      width: width,
      height: height,
      child: CupertinoActivityIndicator(radius: min(10.0,width/3)),
    );
  }


  static Widget error({double width, double height, double size}) {
    return SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.error_outline,
          size: size,
        ));
  }
}