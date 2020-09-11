


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
class IconFonts {
  IconFonts._();

  /// iconfont:flutter base
  static const String fontFamily = 'iconfont';

  static const IconData pageEmpty = IconData(0xe63c, fontFamily: fontFamily);
  static const IconData pageError = IconData(0xe600, fontFamily: fontFamily);
  static const IconData pageNetworkError = IconData(0xe678, fontFamily: fontFamily);
  static const IconData pageUnAuth = IconData(0xe65f, fontFamily: fontFamily);
}