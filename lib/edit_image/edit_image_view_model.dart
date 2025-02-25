import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_case/edit_image/effect_view.dart';
import 'package:opencv_case/edit_image/filter_view.dart';
import 'package:opencv_case/effect_data.dart';
import 'package:opencv_case/functions.dart';
import 'package:opencv_case/general_filter.dart';
import 'package:opencv_dart/opencv.dart';
import 'package:path/path.dart' as p;

class EditImageViewModel extends ChangeNotifier {
  XFile? imageFile;
  Filter? currentFilter;
  int settingsPageIndex = 0;
  EffectData? currentEffect;
  EffectHistory? currentHistory;
  List<Widget> settingsPages = [
    const EffectSettingsView(),
    const FilterSettingsView(),
  ];
  List<Uint8List> images = [];
  List<EffectHistory> effectHistory = [];
  Uint8List? showingImage;
  void setPage(int val) {
    settingsPageIndex = val;
    notifyListeners();
  }

  void setEffect(EffectData val) {
    if (currentEffect?.id == val.id) {
      // Aynı efekti tekrar seçtiysek temizle
      currentEffect = null;
      currentHistory = null;
    } else {
      // Önceki efektin değeri değiştiyse kaydet
      if (currentHistory != null &&
          currentEffect != null &&
          currentHistory!.startValue != currentHistory!.endValue) {
        effectHistory.add(
          EffectHistory(
            id: currentHistory!.id,
            label: currentHistory!.label,
            startValue: currentHistory!.startValue,
            endValue: currentHistory!.endValue,
          ),
        );
      }

      // Yeni efekti kaydet
      currentEffect = val;
      currentHistory = EffectHistory(
        id: val.id,
        label: val.label,
        startValue: val.sliderValue,
        endValue: val.sliderValue,
      );
    }
    notifyListeners();
  }

  void undo(int index) {
    if (index < 0 || index >= images.length - 1) {
      return;
    }

    // liste1'i index + 1 uzunluğa kısalt
    images = images.sublist(0, index + 1);

    // liste2'yi index uzunluğa kısalt
    effectHistory = effectHistory.sublist(0, index);
    currentEffect = null;
    currentHistory = null;

    showingImage = images.last;
    notifyListeners();
  }

  Future<bool> initImageData(XFile val) async {
    if (await File(val.path).exists()) {
      clearAll();
      imageFile = val;
      notifyListeners();
      Uint8List? tmpData = await Isolate.run(() async {
        String path = val.path;
        Mat tmp = imread(path);
        return imencode(p.extension(path), tmp).$2;
      });
      if (tmpData != null) {
        images.add(tmpData);
        showingImage = tmpData;
        notifyListeners();
        return true;
      }
      return false;
    }
    return false;
  }

  void clearAll() {
    imageFile = null;
    currentEffect = null;
    currentFilter = null;
    showingImage = null;
    currentHistory = null;
    images.clear();
    effectHistory.clear();
    notifyListeners();
  }

  void sliderChanged(double val) {
    if (currentEffect != null) {
      currentEffect!.sliderValue = double.parse(val.toStringAsFixed(2));
      notifyListeners();
    }
  }

  void setHistoryEnd(double val) {
    currentHistory!.endValue = val;
    sliderApply();
  }

  void addHistory() {
    currentHistory!.endValue = currentEffect!.sliderValue;
    // Değer değişmişse history'e ekle
    effectHistory.add(
      EffectHistory(
        id: currentHistory!.id,
        label: currentHistory!.label,
        startValue: currentHistory!.startValue,
        endValue: currentHistory!.endValue,
      ),
    );

    // Yeni başlangıç değeri olarak şu anki değeri ata
    currentHistory = EffectHistory(
      id: currentEffect!.id,
      label: currentEffect!.label,
      startValue: currentEffect!.sliderValue,
      endValue: currentEffect!.sliderValue,
    );
  }

  void sliderApply() {
    if (currentHistory!.startValue != currentHistory!.endValue) {
      addHistory();
      _applyEffect(showingImage!);
    }
  }

  void _applyEffect(Uint8List x) async {
    String extension = p.extension(imageFile!.path);
    late Uint8List newImg;
    switch (currentEffect!.id) {
      case "gaussian_blur":
        newImg = await EffectFunctions.gaussianBlur(
          x,
          currentEffect!.sliderValue,
          extension,
        );
        debugPrint("gaussian_blur");
        break;
      case "contrast":
        newImg = await EffectFunctions.adjustContrast(
          x,
          currentEffect!.sliderValue,
          extension,
        );
        debugPrint("contrast");
        break;
      case "brightness":
        newImg = await EffectFunctions.adjustBrightness(
          x,
          currentEffect!.sliderValue,
          extension,
        );
        debugPrint("brightness");
        break;
      default:
    }
    images.add(newImg);
    showingImage = newImg;
    notifyListeners();
  }
}
