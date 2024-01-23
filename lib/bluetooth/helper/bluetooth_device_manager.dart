import 'dart:async';

import 'package:mobi_bt_iot/mobi_bt_iot.dart';

class BluetoothServiceManager {
  BluetoothServiceManager({
    required this.bluetoothHelper,
  });

  final BluetoothHelper bluetoothHelper;
  final DeviceConfig deviceConfig = DeviceConfig();
  StreamSubscription? _notifySubscription;

  Future<BluetoothDevice> getConnectedDevice() async {
    var connectedDevice = bluetoothHelper.getConnectedDevice();
    if (connectedDevice == null) {
      throw BluetoothException('No connected device found');
    }
    return connectedDevice;
  }

  Future<BluetoothService> getService({
    required BluetoothDevice device,
  }) async {
    List<BluetoothService> services = await device.discoverServices();
    return services.firstWhere(
      (s) =>
          s.uuid.toString().toUpperCase() == deviceConfig.getDeviceListUid()[0],
      orElse: () => throw BluetoothException('Service not found'),
    );
  }

  Future<BluetoothCharacteristic> getCharacteristic({
    required BluetoothService service,
    required int characteristicIndex,
  }) async {
    return service.characteristics.firstWhere(
      (c) =>
          c.uuid.toString().toUpperCase() ==
          deviceConfig.getDeviceListUid()[characteristicIndex],
      orElse: () => throw BluetoothException('Characteristic not found'),
    );
  }

  Future<void> writeAndNotify({
    required BluetoothCharacteristic writeCharacteristic,
    required BluetoothCharacteristic notifyCharacteristic,
    required List<int> message,
    required Function(List<int>) onResponse,
  }) async {
    await writeCharacteristic.write(message);
    await notifyCharacteristic.setNotifyValue(true);
    await _unsubscribeNotify();
    _notifySubscription = notifyCharacteristic.lastValueStream.listen((
      responseBleDevice,
    ) {
      onResponse(
        responseBleDevice,
      );
    });
  }

  Future<void> _unsubscribeNotify() async {
    if (_notifySubscription != null) {
      await _notifySubscription!.cancel();
      _notifySubscription = null;
    }
  }
}

class BluetoothException implements Exception {
  String message;
  BluetoothException(this.message);

  @override
  String toString() {
    return "BluetoothException: $message";
  }
}
