import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/core/utils/app_logger.dart';
import 'app/core/utils/device_utils.dart';
import 'my_app.dart';


void main() {
  //===========>> Top-level error handling zone <<============
  runZonedGuarded(
        () async {
      //===========>> Flutter binding initialize <<============
      WidgetsFlutterBinding.ensureInitialized();

      _setupFlutterErrorHandler();

      // 1) Device orientation lock
      await _initDeviceOrientation();



      // 3) Run the app
      runApp(const ProviderScope(child: MyApp()));
    },
        (error, stackTrace) {
      AppLogger.e('Uncaught zone error: $error');
      AppLogger.e('[MAIN] Uncaught zone StackTrace: $stackTrace');
    },
  );
}

//===========>> Flutter framework error handler <<============
void _setupFlutterErrorHandler() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    AppLogger.e('[FLUTTER ERROR] ${details.exception}');
    if (details.stack != null) {
      AppLogger.e(details.stack.toString());
    }
  };
}

//===========>> Device orientation lock <<============
Future<void> _initDeviceOrientation() async {
  try {
    await DeviceUtils.lockDevicePortrait();
    AppLogger.i('[MAIN] Orientation locked to portrait');
  } catch (e, st) {
    AppLogger.e('[MAIN] Failed to lock orientation: $e');
    AppLogger.e(st.toString());
  }
}

