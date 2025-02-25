import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opencv_case/edit_image/edit_image_view_model.dart';
import 'package:provider/provider.dart';

class EndDrawerView extends StatelessWidget {
  const EndDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditImageViewModel>(
      builder:
          (context, eivm, child) => Drawer(
            width: 160.w,
            backgroundColor: Colors.white,
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // İlk olarak Raw Image için bir buton ekleyelim
                  GestureDetector(
                    onTap: () {
                      eivm.undo(0); // Raw Image'e dönüş
                      context.pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.memory(
                        eivm.images.first,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // effectHistory içeriğini dinamik olarak oluşturuyoruz
                  ...List.generate(
                    eivm.effectHistory.length,
                    (index) => GestureDetector(
                      onTap: () {
                        eivm.undo(index + 1); // Raw Image olduğu için index + 1
                        context.pop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              eivm.effectHistory[index].label,
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontSize: 18.sp,
                                height: 20.w / 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20.w),
                            Text(
                              "${eivm.effectHistory[index].startValue} -> ${eivm.effectHistory[index].endValue}",
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                height: 20.w / 15,
                              ),
                            ),
                          ],
                        ),
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
