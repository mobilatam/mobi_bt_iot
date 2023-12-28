import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserConfig {
  static final UserConfig _instance = UserConfig._internal();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  factory UserConfig() {
    return _instance;
  }

  String deviceUniqueKey = 'yOTmK50z';
  List<int> deviceInfo = [];
  int _deviceKey = 0;

  int get deviceKey => _deviceKey;

  UserConfig._internal();

  int getDeviceKey() {
    return deviceKey;
  }

  set setDeviceKey(int newDeviceKey) {
    _deviceKey = newDeviceKey;
  }

  get getDeviceUniqueKey {
    return deviceUniqueKey;
  }

  set setDeviceUniqueKey(
    String newDeviceUniqueKey,
  ) {
    deviceUniqueKey = newDeviceUniqueKey;
  }

  List<int> getDeviceInfo() {
    return getDeviceInfo();
  }

  void setDeviceInfo({
    required List<int> responseDeviceInfo,
  }) {
    deviceInfo = responseDeviceInfo;
  }
}
