abstract class DeviceManagerInterface {
  Future<void> getCkey({
    required String deviceKey,
  });

  Future<void> unlockDevice({
    required int ckey,
  });

  Future<void> lockDevice({
    required int ckey,
  });

  Future<void> infoDevice({
    required int ckey,
  });

  Future<void> lockInfo({
    required int ckey,
  });

  Future<void> setScooter({
    required int ckey,
    required int velocity,
    required int headLight,
  });

  Future<void> getUuidCommunication();
}
