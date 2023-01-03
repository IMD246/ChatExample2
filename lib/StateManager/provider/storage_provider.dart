import 'package:flutter/foundation.dart';

import '../../repositories/remote_repository/remote_storage_repository.dart';

class StorageProvider extends ChangeNotifier {
  final RemoteStorageRepository remoteStorageRepository;
  StorageProvider({
    required this.remoteStorageRepository,
  });
}
