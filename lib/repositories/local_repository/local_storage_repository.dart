import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalStorageRepository {
  Future<String?> getFile({
    required String fileName,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      File file = File(filePath);
      if (await file.exists()) {
        return file.path;
      }
      return null;
    } catch (e) {
      log(
        e.toString(),
      );
      return null;
    }
  }

  Future<void> uploadFile({
    required String fileName,
    required String remotePath,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    
    final filePath = '${directory.path}/$fileName';

    if (filePath.isEmpty) {
      return;
    }

    final response = await http.get(
      Uri.parse(
        remotePath,
      ),
    );
    if (response.statusCode == 200) {
      File file = File(filePath);

      await file.writeAsBytes(response.bodyBytes);
    }
  }
}
