abstract class DeviceManagerInterface {
  Future<void> getCkey({
    required String deviceKey,
  });

  Future<void> unlock({
    required int ckey,
  });

  Future<void> lock({
    required int ckey,
  });

  Future<void> info({
    required int ckey,
  });
}
