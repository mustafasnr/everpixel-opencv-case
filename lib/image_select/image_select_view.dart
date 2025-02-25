import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_case/edit_image/edit_image_view_model.dart';
import 'package:opencv_case/image_select/image_select_view_model.dart';
import 'package:provider/provider.dart';

class ImageSelectView extends StatelessWidget {
  const ImageSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Consumer<ImageSelectViewModel>(
            builder:
                (context, isvm, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 500.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      clipBehavior: Clip.hardEdge,
                      child:
                          isvm.data != null
                              ? Image.file(
                                File(isvm.image!.path),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fill,
                              )
                              : Image.asset(
                                "assets/placeholder.jpg",
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                    ),
                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: () async {
                        await bottomSheetView(context);
                      },
                      child: Text(
                        "Resim Seç",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: () {
                        debugPrint("TEST");
                      },
                      child: Text(
                        "Isolate Test Button",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextButton(
                      onPressed: () async {
                        if (isvm.data != null && isvm.imageReady) {
                          final eivm = context.read<EditImageViewModel>();
                          if (await eivm.initImageData(isvm.image!)) {
                            if (context.mounted) {
                              context.push("/edit_image");
                            }
                          } else {
                            if (context.mounted) {
                              await showDialog(
                                context: context,
                                builder:
                                    (context) => Dialog(
                                      child: Text("Bir hata meydana geldi"),
                                    ),
                              );
                            }
                          }
                        }
                      },
                      child: Text(
                        "Düzenlemeye Başla",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> bottomSheetView(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder:
          (context) => SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      context.read<ImageSelectViewModel>().setImage(
                        ImageSource.gallery,
                      );
                      if (context.mounted) context.pop();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.image, size: 28.sp, color: Colors.black87),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "Galeriden Seç",
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade300),
                  InkWell(
                    onTap: () async {
                      context.read<ImageSelectViewModel>().setImage(
                        ImageSource.camera,
                      );
                      if (context.mounted) context.pop();
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 16.w,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 28.sp,
                            color: Colors.black87,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "Kameradan Çek",
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
