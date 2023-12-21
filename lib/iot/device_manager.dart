import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/iot/device_manager_interface.dart';
import 'package:mobi_bt_iot/iot/scooter_command_helper.dart';

import '../bluetooth/bluetooth_helper.dart';
import 'ble_utils.dart';
///todo: transformar a helper

// class DeviceManager implements DeviceManagerInterface {
//   DeviceManager({
//     required this.bluetoothHelper,
//   });
//
//   final BluetoothHelper bluetoothHelper;
//
//   @override
//   Future<void> retrieveKey() async {
//     var connectedDevice = bluetoothHelper.getConnectedDevice();
//
//     if (connectedDevice == null) {
//       throw Exception('No hay ningún dispositivo conectado.');
//     }
//
//     List<BluetoothService> services = await connectedDevice.discoverServices();
//
//     BluetoothService service = services.firstWhere(
//       (s) => s.uuid.toString().toUpperCase() == '6E400001-B5A3-F393-E0A9-E50E24DCCA9E',
//       orElse: () => throw Exception('Servicio no encontrado.'),
//     );
//
//     BluetoothCharacteristic notifyCharacteristic = service.characteristics.firstWhere(
//       (c) => c.uuid.toString().toUpperCase() == '6E400003-B5A3-F393-E0A9-E50E24DCCA9E',
//       orElse: () => throw Exception('Característica de notificación no encontrada.'),
//     );
//
//     BluetoothCharacteristic writeCharacteristic = service.characteristics.firstWhere(
//       (c) => c.uuid.toString().toUpperCase() == '6E400002-B5A3-F393-E0A9-E50E24DCCA9E',
//       orElse: () => throw Exception('Característica de escritura no encontrada.'),
//     );
//
//     List<int> message = ScooterCommand.getCRCCommunicationKey('c');
//
//     await writeCharacteristic.write(message);
//     await notifyCharacteristic.setNotifyValue(true);
//     notifyCharacteristic.value.listen((values) {
//       processReceivedValues(values);
//     });
//   }
//
//   @override
//   Future<void> unlock() async {}
//   @override
//   Future<void> lock() async {}
//   @override
//   Future<void> info() async {}
// }

class DeviceManager implements DeviceManagerInterface {
  DeviceManager({
    required this.bluetoothHelper,
  });

  final BluetoothHelper bluetoothHelper;
  final ScooterCommandHelper scooterCommandHelper = ScooterCommandHelper();


  @override
  Future<void> retrieveKey() async {
    var connectedDevice = bluetoothHelper.getConnectedDevice();

    if (connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }

    List<BluetoothService> services = await connectedDevice.discoverServices();

    BluetoothService service = services.firstWhere(
          (s) => s.uuid.toString().toUpperCase() == '6E400001-B5A3-F393-E0A9-E50E24DCCA9E',
      orElse: () => throw Exception('Servicio no encontrado.'),
    );

    BluetoothCharacteristic notifyCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == '6E400003-B5A3-F393-E0A9-E50E24DCCA9E',
      orElse: () => throw Exception('Característica de notificación no encontrada.'),
    );

    BluetoothCharacteristic writeCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == '6E400002-B5A3-F393-E0A9-E50E24DCCA9E',
      orElse: () => throw Exception('Característica de escritura no encontrada.'),
    );
    List<int> message = scooterCommandHelper.getCRCCommunicationKey(deviceKey: 'c');

    await writeCharacteristic.write(message);
    await notifyCharacteristic.setNotifyValue(true);
    notifyCharacteristic.value.listen((values) {
      processReceivedValues(values: values);
    });
  }

  @override
  Future<void> unlock() async {}
  @override
  Future<void> lock() async {}
  @override
  Future<void> info() async {}
}
