abstract class DeviceManagerInterface {
  Future<void> getCkey({
    required String deviceKey,
  }) async {}

  Future<void> unlockDevice({
    required int ckey,
  }) async {}

  Future<void> lockDevice({
    required int ckey,
  }) async {}

  Future<void> infoDevice({
    required int ckey,
  }) async {}

  Future<void> getUuidCommunication() async {}
}
