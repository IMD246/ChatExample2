import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
abstract class StorageRepository {
  Future<void> uploadMultipleFile({
    required List<PlatformFile> listFile,
    required String path,
  });

  Future<void> uploadFile({
    required File file,
    required String filePath,
    required String fileName,
    SettableMetadata? settableMetaData
  });

  Future<String?> getFile({
    required String filePath,
    required String fileName,
  });
}
