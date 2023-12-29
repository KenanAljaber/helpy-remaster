import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class UtilityMethods {
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static bool isMobile (BuildContext context) {
    try {
    if(UtilityMethods.getScreenSize(context).width < 600) {
      return true;
     }
     return false;
    
    } catch (e) {
      print("an error occured");
      return false;
    }
  }

  static void hideStatusBar() {
    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } catch (e) {
      return;
    }
  }

  static Future<bool> isServiceEnabled(Permission service) async {
    try {
      final status = await service.status;
      if (status.isDenied || status.isRestricted) {
        print("Permission Denied");
        return false;
      }
      print("Permission Granted");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> requestPermission(Permission service) async {
    try {
      if (await service.request().isGranted) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
