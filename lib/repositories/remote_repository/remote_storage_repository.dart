import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../interface_repository/storage_repository.dart';

class RemoteStorageRepository implements StorageRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<String> getFile({
    required String filePath,
    required String fileName,
  }) async {
    try {
      final refPath = "$filePath/$fileName";
      String downloadURL = await storage.ref(refPath).getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (_) {
      return "";
    }
  }

  @override
  Future<void> uploadMultipleFile({
    required List<PlatformFile> listFile,
    required String path,
  }) async {
    try {
      for (var element in listFile) {
        final file = File(element.path!);
        await uploadFile(
          file: file,
          filePath: path,
          fileName: element.name,
        );
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> uploadFile({
    required File file,
    required String filePath,
    required String fileName,
    SettableMetadata? settableMetaData,
  }) async {
    try {
      final refPath = "$filePath/$fileName";
      await storage
          .ref(refPath)
          .putFile(
            file,
            settableMetaData,
          )
          .then(
        (p0) async {
          return true;
        },
      );
    } on FirebaseException catch (e) {
      log(e.toString());
      return false;
    }
    return false;
  }
}
