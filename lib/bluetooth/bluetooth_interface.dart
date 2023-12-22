import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/bluetooth/models/device_model.dart';
import 'package:mobi_bt_iot/bluetooth/models/service_model.dart';

abstract class BluetoothDeviceInterface {
  Future<void> startScan();

  Future<void> stopScan();

  Future<void> connectToDevice({
    required String address,
  });

  Future<void> disconnectFromDevice({
    required String address,
  });

  Stream<List<DeviceModel>> getDiscoveredDevicesStream();

  Stream<List<ServiceModel>> getDeviceServices();

  BluetoothDevice? getConnectedDevice();
}
