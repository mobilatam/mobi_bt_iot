class DeviceConfig {
  factory DeviceConfig() {
    return _instance;
  }

  static final DeviceConfig _instance = DeviceConfig._internal();

  DeviceConfig._internal();

  String deviceMac = '';

  ///Todo: Hashing deviceUniqueKey or coming from environment variable
  String deviceUniqueKey = 'yOTmK50z';
  int deviceCkey = 0;
  List<int> deviceInfo = [];
  List<String> deviceListUid = [];
  int deviceLockStatus = 0;

  bool isLightOn = true;
  bool isScooterUnlock = true;
  int selectedVelocity = 3;

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

  int getDeviceLockStatus() {
    return deviceLockStatus;
  }

  void setDeviceLockStatus({
    required int newDeviceLockStatus,
  }) {
    deviceLockStatus = newDeviceLockStatus;
  }

  bool getIsLightOn() {
    return isLightOn;
  }

  void setIsLightOn({
    required bool newIsLightOn,
  }) {
    isLightOn = newIsLightOn;
  }

  bool getIsScooterUnlock() {
    return isScooterUnlock;
  }

  void setIsScooterUnlock({
    required bool newIsScooterUnlock,
  }) {
    isScooterUnlock = newIsScooterUnlock;
  }

  int getSelectedVelocity() {
    return selectedVelocity;
  }

  void setSelectedVelocity({
    required int newSelectedVelocity,
  }) {
    selectedVelocity = newSelectedVelocity;
  }
}
