import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_dart/opencv_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

class ImageSelectViewModel extends ChangeNotifier {
  XFile? image;
  Uint8List? data;
  bool imageReady = false;
  Future<void> setImage(ImageSource sourceType) async {
    late Mat tmp;
    // late Mat gry;
    late Uint8List gryData;
    if (await _requestPermissions()) {
      final file = await ImagePicker().pickImage(source: sourceType);
      if (file != null) {
        imageReady = false;
        notifyListeners();
        gryData = await Isolate.run(() async {
          final String filePath = file.path;
          tmp = imread(filePath);
          return imencode(p.extension(filePath), tmp).$2;
        });
        data = gryData;
        imageReady = true;
        image = file;
        notifyListeners();
      }
    }
  }

  Future<bool> _requestPermissions() async {
    await [Permission.camera, Permission.mediaLibrary].request();
    bool cameraStatus = await Permission.camera.isGranted;
    bool mediaStatus = await Permission.mediaLibrary.isGranted;
    return cameraStatus && mediaStatus;
  }
}
