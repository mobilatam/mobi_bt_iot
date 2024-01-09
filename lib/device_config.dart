class DeviceConfig {
  static final DeviceConfig _instance = DeviceConfig._internal();

  factory DeviceConfig() {
    return _instance;
  }
  String deviceMac = '';
  String deviceUniqueKey = 'yOTmK50z';
  int deviceCkey = 0;
  List<int> deviceInfo = [];
  List<String> deviceListUid = [];

  DeviceConfig._internal();

  String getDeviceMac() {
    return deviceMac;
  }

  void setDeviceMac({
    required String newDeviceMac,
  }) {
    deviceMac = newDeviceMac;
  }

  int getDeviceCkey() {
    return deviceCkey;
  }

  void setDeviceCkey({
    required int newDeviceCkey,
  }) {
    deviceCkey = newDeviceCkey;
  }

  String getDeviceUniqueKey() {
    return deviceUniqueKey;
  }

  void setDeviceUniqueKey({
    required String newDeviceUniqueKey,
  }) {
    deviceUniqueKey = newDeviceUniqueKey;
  }

  List<int> getDeviceInfo() {
    return deviceInfo;
  }

  void setDeviceInfo({
    required List<int> responseDeviceInfo,
  }) {
    deviceInfo = responseDeviceInfo;
  }

  List<String> getDeviceListUid() {
    return deviceListUid;
  }

  void setDeviceListUid({
    required List<String> newDeviceListUid,
  }) {
    deviceListUid = newDeviceListUid;
  }
}
