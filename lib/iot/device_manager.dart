import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';

import '../bluetooth/bluetooth_helper.dart';

//todo: transformar a helper
class DeviceManager {
  DeviceManager({
    required this.bluetoothHelper,
  });

  final BluetoothHelper bluetoothHelper;

  Future<void> retrieveKey() async {
    var connectedDevice = bluetoothHelper.getConnectedDevice();

    if (connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }

    List<BluetoothService> services = await connectedDevice.discoverServices();

    BluetoothService service = services.firstWhere(
          (s) =>
      s.uuid.toString().toUpperCase() ==
          '6E400001-B5A3-F393-E0A9-E50E24DCCA9E',
      orElse: () => throw Exception('Servicio no encontrado.'),
    );

    BluetoothCharacteristic notifyCharacteristic =
    service.characteristics.firstWhere(
          (c) =>
      c.uuid.toString().toUpperCase() ==
          '6E400003-B5A3-F393-E0A9-E50E24DCCA9E',
      orElse: () =>
      throw Exception('Característica de notificación no encontrada.'),
    );

    BluetoothCharacteristic writeCharacteristic =
    service.characteristics.firstWhere(
          (c) =>
      c.uuid.toString().toUpperCase() ==
          '6E400002-B5A3-F393-E0A9-E50E24DCCA9E',
      orElse: () =>
      throw Exception('Característica de escritura no encontrada.'),
    );

    List<int> message = ScooterCommand.getCRCCommunicationKey('c');

    await writeCharacteristic.write(message);
    await notifyCharacteristic.setNotifyValue(true);
    notifyCharacteristic.value.listen((values) {
      processReceivedValues(values);
    });
  }

  Future<void> unlock() async {}
  Future<void> lock() async {}
  Future<void> info() async {}
}