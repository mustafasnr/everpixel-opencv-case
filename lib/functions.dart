import 'dart:isolate';
import 'dart:typed_data';

import 'package:opencv_dart/opencv.dart';

class EffectFunctions {
  EffectFunctions._(); // Private constructor: Sınıf örneği oluşturulamaz.

  static Future<Uint8List> gaussianBlur(
    Uint8List x,
    double value,
    String extension,
  ) async {
    int kernelSize = value.toInt() == 0 ? 1 : value.toInt() * 2 - 1;
    Uint8List bluredImage = await Isolate.run(() async {
      Mat tmp = imdecode(x, 4);
      tmp = await gaussianBlurAsync(tmp, (kernelSize, kernelSize), 0);
      final result = await imencodeAsync(extension, tmp);
      return result.$2;
    });
    return bluredImage;
  }

  // Brightness Ayarı (Parlaklık)
  static Future<Uint8List> adjustBrightness(
    Uint8List x,
    double value,
    String extension,
  ) async {
    Uint8List result = await Isolate.run(() async {
      Mat tmp = imdecode(x, 4);

      tmp = await convertScaleAbsAsync(
        tmp,
        beta: value * 10,
      ); // α = value, β = 0
      final encodeResult = await imencodeAsync(extension, tmp);
      return encodeResult.$2;
    });
    return result;
  }

  // Contrast Ayarı
  static Future<Uint8List> adjustContrast(
    Uint8List x,
    double value,
    String extension,
  ) async {
    Uint8List result = await Isolate.run(() async {
      Mat tmp = imdecode(x, 4);

      tmp = await convertScaleAbsAsync(tmp, alpha: value); // α = value, β = 0
      final encodeResult = await imencodeAsync(extension, tmp);
      return encodeResult.$2;
    });
    return result;
  }
}
