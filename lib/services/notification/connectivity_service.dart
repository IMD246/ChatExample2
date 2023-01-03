import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityService {
  ReplaySubject<bool> subjectStatusConnection = ReplaySubject<bool>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen(
      (event) {
        final status = _getStatusConnection(event);
        subjectStatusConnection.add(
          status,
        );
      },
    );
  }
}

bool _getStatusConnection(ConnectivityResult result) {
  switch (result) {
    case ConnectivityResult.mobile:
    case ConnectivityResult.ethernet:
    case ConnectivityResult.wifi:
      return true;
    case ConnectivityResult.none:
    default:
      return false;
  }
}
