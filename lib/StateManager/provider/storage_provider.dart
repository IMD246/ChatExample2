import 'package:flutter/foundation.dart';

import '../../repositories/local_repository/local_storage_repository.dart';
import '../../repositories/remote_repository/remote_storage_repository.dart';

class StorageProvider extends ChangeNotifier {
  final RemoteStorageRepository remoteStorageRepository;
  final LocalStorageRepository localStorageRepository;
  StorageProvider({
    required this.remoteStorageRepository,
    required this.localStorageRepository,
  });
}
