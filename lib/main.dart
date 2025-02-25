import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opencv_case/edit_image/edit_image_view_model.dart';
import 'package:opencv_case/image_select/image_select_view_model.dart';
import 'package:opencv_case/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 900),
      builder:
          (context, child) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (c) => ImageSelectViewModel()),
              ChangeNotifierProvider(create: (c) => EditImageViewModel()),
            ],
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
            ),
          ),
    );
  }
}
