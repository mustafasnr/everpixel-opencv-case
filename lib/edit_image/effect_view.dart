import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opencv_case/edit_image/edit_image_view_model.dart';
import 'package:opencv_case/effect_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EffectSettingsView extends StatelessWidget {
  const EffectSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<EffectData> effects = [
      EffectData(
        iconData: Icons.blur_on,
        id: "gaussian_blur",
        label: "Gaussian Blur",
        sliderMax: 10,
        sliderMin: 0,
        sliderValue: 0, //init value
        sliderdiv: 20,
      ),
      EffectData(
        iconData: Icons.contrast,
        id: "contrast",
        label: "Contrast",
        sliderMax: 2.5,
        sliderMin: 0.5,
        sliderValue: 1,
        sliderdiv: 20,
      ),
      EffectData(
        iconData: Icons.wb_sunny,
        id: "brightness",
        label: "Brightness",
        sliderMax: 10,
        sliderMin: -10,
        sliderValue: 0,
        sliderdiv: 20,
      ),
    ];
    return Consumer<EditImageViewModel>(
      builder:
          (context, eivm, child) => Column(
            children: [
              eivm.currentEffect != null
                  ? SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor:
                          Colors.blueAccent, // Kaydırılan track rengi
                      inactiveTrackColor: Colors.grey[300], // Pasif track rengi
                      trackHeight: 6.0, // Track kalınlığı
                      thumbColor:
                          Colors.blueAccent, // Thumb (sürüklenen nokta) rengi
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 10.0,
                      ), // Thumb şekli
                      overlayColor: Colors.blue.withValues(
                        alpha: 0.2,
                      ), // Thumb etrafındaki efekt rengi
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 20.0,
                      ), // Efekt büyüklüğü
                      tickMarkShape:
                          RoundSliderTickMarkShape(), // Bölme noktalarının şekli
                      activeTickMarkColor:
                          Colors.blue, // Aktif bölme noktası rengi
                      inactiveTickMarkColor:
                          Colors.grey[400], // Pasif bölme noktası rengi
                      valueIndicatorShape:
                          PaddleSliderValueIndicatorShape(), // Değer gösterge şekli
                      valueIndicatorColor:
                          Colors.blueAccent, // Değer göstergesinin rengi
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ), // Değer göstergesinin yazı rengi
                    ),
                    child: Slider(
                      value: eivm.currentEffect!.sliderValue,
                      min: eivm.currentEffect!.sliderMin,
                      max: eivm.currentEffect!.sliderMax,
                      divisions: eivm.currentEffect!.sliderdiv,
                      onChanged: eivm.sliderChanged,
                      onChangeEnd: (value) {
                        eivm.sliderChanged(value);
                        eivm.setHistoryEnd(value);
                      },
                      label:
                          eivm
                              .currentEffect!
                              .currentValue, // Yuvarlatılmış gösterim
                    ),
                  )
                  : SizedBox.shrink(),
              Container(
                height: 64.r + 24.sp, // Yüksekliği belirle
                margin: EdgeInsets.only(top: 8.h),
                alignment: Alignment.centerLeft,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Yatay kaydırma
                  itemCount: effects.length,
                  itemBuilder: (context, index) {
                    return Tooltip(
                      message: effects[index].label,
                      child: GestureDetector(
                        onTap: () {
                          eivm.setEffect(effects[index]);
                        },
                        child: Container(
                          margin:
                              index != effects.length - 1
                                  ? EdgeInsets.only(right: 8.w)
                                  : EdgeInsets.zero,
                          width: 64.r + 16.r,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                minRadius: 32.r,
                                maxRadius: 32.r,
                                child: Icon(
                                  effects[index].iconData,
                                  size: 24.sp,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                effects[index].label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  height: 20 / 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }
}
