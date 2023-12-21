///todo: implementar interface device manager

abstract class DeviceManagerInterface {
  Future<void> retrieveKey();
  Future<void> unlock();
  Future<void> lock();
  Future<void> info();
}