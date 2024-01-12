import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mobi_bt_iot/bluetooth/helper/bluetooth_helper.dart';
import 'package:mobi_bt_iot/iot/config/device_config.dart';

class BluetoothServiceManager {
  BluetoothServiceManager({
    required this.bluetoothHelper,
  });

  final BluetoothHelper bluetoothHelper;
  final DeviceConfig deviceConfig = DeviceConfig();
  StreamSubscription? _notifySubscription;

  Future<BluetoothDevice?> getConnectedDevice() async {
    var connectedDevice = bluetoothHelper.getConnectedDevice();
    if (connectedDevice == null) {
      log('No connected device');
    }
    return connectedDevice;
  }

  Future<BluetoothService> getService({
    required BluetoothDevice? device,
  }) async {
    List<BluetoothService> services = await device!.discoverServices();
    return services.firstWhere(
      (s) =>
          s.uuid.toString().toUpperCase() == deviceConfig.getDeviceListUid()[0],
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
    );
  }

  Future<void> writeAndNotify({
    required BluetoothCharacteristic writeCharacteristic,
    required BluetoothCharacteristic notifyCharacteristic,
    required List<int> message,
    required Function(List<int>) onResponse,
  }) async {
    await writeCharacteristic.write(
      message,
    );
    await notifyCharacteristic.setNotifyValue(
      true,
    );
    _unsubscribeNotify();
    _notifySubscription = notifyCharacteristic.lastValueStream.listen((
      responseBleDevice,
    ) {
      onResponse(responseBleDevice);
    });
  }

  void _unsubscribeNotify() {
    _notifySubscription?.cancel();
    _notifySubscription = null;
  }
}
