import 'package:flutter/services.dart';

class DeviceUtils {

  //=====================LockDevicePortrait=============
  static  lockDevicePortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}