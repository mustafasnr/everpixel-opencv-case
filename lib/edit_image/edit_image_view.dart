import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opencv_case/edit_image/edit_image_view_model.dart';
import 'package:opencv_case/edit_image/end_drawer_view.dart';
import 'package:opencv_case/general_filter.dart';
import 'package:provider/provider.dart';

class EditImageView extends StatelessWidget {
  const EditImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: Consumer<EditImageViewModel>(
        builder:
            (context, eivm, child) => BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: eivm.settingsPageIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Filtre",
                  tooltip: "Filtre",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.filter_sharp),
                  label: "Ayarlama",
                  tooltip: "Ayarlama",
                ),
              ],
              onTap: eivm.setPage,
            ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Consumer<EditImageViewModel>(
            builder:
                (context, eivm, child) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Düzenle",
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            hoverColor: Colors.black.withValues(alpha: 0.075),
                            onTap: () {
                              scaffoldKey.currentState!.openEndDrawer();
                            },
                            borderRadius: BorderRadius.circular(300.r),
                            child: Padding(
                              padding: EdgeInsets.all(5.r),
                              child: Icon(
                                Icons.history,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // anlık resim
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      width: double.infinity,
                      height: 500.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child:
                          eivm.showingImage == null
                              ? Text(
                                "asds",
                                style: GoogleFonts.urbanist(
                                  fontSize: 32.sp,
                                  color: Colors.black,
                                ),
                              )
                              : Image.memory(
                                eivm.showingImage!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fill,
                              ),
                    ),
                    const Spacer(),
                    //efekte göre açılacak yer burası ----- bottom nav bar burayı etkiliyor
                    eivm.settingsPages[eivm.settingsPageIndex],
                  ],
                ),
          ),
        ),
      ),
      endDrawer: EndDrawerView(),
    );
  }
}

class FilterSection extends StatelessWidget {
  final Filter filter;
  const FilterSection({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    if (filter.type == FilterType.value) {
      return SizedBox();
    } else if (filter.type == FilterType.slider) {
      return Slider(
        value: filter.slider1!,
        min: filter.slider1Min!,
        max: filter.slider1Max!,
        divisions: filter.slider1div!,
        onChanged: (value) {
          filter.setSlider1(value);
        },
      );
    }
    return SizedBox.shrink();
  }
}
