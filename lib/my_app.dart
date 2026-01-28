import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/core/routes/app_router.dart';
import 'app/feature/widgets/custom_text.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ================>>Global ErrorWidget for production <<=============
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Center(
        child: CustomText(
          text: "Other",
          fontSize: 16.sp,
          color: Colors.red,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      );
    };

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.route,
        );
      },
    );
  }
}