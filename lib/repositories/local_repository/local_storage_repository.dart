import 'dart:io';

import 'package:file_picker/src/platform_file.dart';
import 'package:firebase_storage_platform_interface/src/settable_metadata.dart';

import '../interface_repository/storage_repository.dart';

class LocalStorageRepository implements StorageRepository {
  @override
  Future<String?> getFile(
      {required String filePath, required String fileName}) {
    // TODO: implement getFile
    throw UnimplementedError();
  }

  @override
  Future<void> uploadMultipleFile(
      {required List<PlatformFile> listFile, required String path}) {
    // TODO: implement uploadMultipleFile
    throw UnimplementedError();
  }

  @override
  Future<bool> uploadFile(
      {required File file,
      required String filePath,
      required String fileName,
      SettableMetadata? settableMetaData}) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }
}
