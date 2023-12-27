import 'package:flutter/material.dart';

class UtilityMethods{
  static Size getScreenSize(BuildContext context){
    return MediaQuery.of(context).size;
  }
}