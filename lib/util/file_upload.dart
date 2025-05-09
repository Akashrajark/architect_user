import 'dart:io';
import 'dart:typed_data';

import 'package:logger/web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> uploadFile(String folder, File file, String fileName) async {
  Uint8List uploadFile = await file.readAsBytes();
  try {
    StorageFileApi storageBucket = Supabase.instance.client.storage.from('docs');

    String filePath = await storageBucket.uploadBinary(
      '$folder/${DateTime.now().millisecondsSinceEpoch.toString()}${formatFileName(fileName)}',
      uploadFile,
    );

    filePath = filePath.replaceRange(0, 5, '');

    return storageBucket.getPublicUrl(filePath);
  } catch (e, s) {
    Logger().e('$e\n$s');
    rethrow;
  }
}

Future<String> uploadFileUint8List(String folder, Uint8List file) async {
  try {
    StorageFileApi storageBucket = Supabase.instance.client.storage.from('docs');

    String filePath = await storageBucket.uploadBinary(
      '$folder/${DateTime.now().millisecondsSinceEpoch.toString()}',
      file,
    );

    filePath = filePath.replaceRange(0, 5, '');

    return storageBucket.getPublicUrl(filePath);
  } catch (e, s) {
    Logger().e('$e\n$s');
    rethrow;
  }
}

String formatFileName(String input) {
  // Use a regular expression to remove any non-alphanumeric characters except the last dot (.)
  RegExp regex = RegExp(r'[^a-zA-Z0-9\.]');

  // Find the position of the last dot to keep the file extension intact
  int lastDotIndex = input.lastIndexOf('.');

  // Split the string into two parts: the main part and the extension
  String mainPart = input.substring(0, lastDotIndex);
  String extension = input.substring(lastDotIndex);

  // Remove unwanted characters from the main part
  mainPart = mainPart.replaceAll(regex, '');

  // Reconstruct the formatted string with the main part and the original extension
  return mainPart + extension;
}
