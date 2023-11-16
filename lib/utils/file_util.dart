import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtil {
  static Future<File> getFileById(String id) async {
    final Directory? appDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final String tempPath = appDir!.path;
    final String fileName = '$id.pdf';
    return File('$tempPath/$fileName');
  }
}
