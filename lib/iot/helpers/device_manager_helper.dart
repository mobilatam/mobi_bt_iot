import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/iot/helpers/scooter_command_helper.dart';
import 'package:mobi_bt_iot/iot/interfaces/device_manager_interface.dart';

import '../../bluetooth/bluetooth_helper.dart';
import '../../user_config.dart';
import '../utils/ble_utils.dart';

///todo: de subscriptions a iot > base command, ble utils, crcUtil, ScooterCommandUtil

class DeviceManagerHelper implements DeviceManagerInterface {
  DeviceManagerHelper(
    this.error, {
    required BluetoothHelper bluetoothHelper,
    required this.uuid,
  })  : _bluetoothHelper = bluetoothHelper,
        _scooterCommandHelper = ScooterCommandHelper();

  final BluetoothHelper _bluetoothHelper;
  final ScooterCommandHelper _scooterCommandHelper;
  final String uuid;
  final String? error;

  final StreamController<List<int>> _deviceCommandStreamController = StreamController<List<int>>.broadcast();

  Stream<List<int>> get deviceCommandStream => _deviceCommandStreamController.stream;

  get getDeviceKey => UserConfig().deviceKey;

  get getDeviceUniqueKey => UserConfig().deviceUniqueKey;

  @override
  Future<void> getCkey({
    required String deviceKey,
  }) async {
    var connectedDevice = _bluetoothHelper.getConnectedDevice();

    if (connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }

    List<BluetoothService> services = await connectedDevice.discoverServices();

    BluetoothService service = services.firstWhere(
      (s) => s.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Servicio no encontrado.'),
    );

    BluetoothCharacteristic notifyCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de notificación no encontrada.'),
    );

    BluetoothCharacteristic writeCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de escritura no encontrada.'),
    );

    List<int> sendMessage = _scooterCommandHelper.getCRCScooterClose(
      deviceUniqueKey: getDeviceUniqueKey,
      ckey: getDeviceKey,
    );

    await writeCharacteristic.write(
      sendMessage,
    );
    await notifyCharacteristic.setNotifyValue(
      true,
    );
    notifyCharacteristic.value.listen((
      responseBleDevice,
    ) async {
      Uint8List? processedValues = await processReceivedValues(
        dataListValues: responseBleDevice,
      );

      if (processedValues != null) {
        UserConfig().setDeviceKey = returnCkeyObtainer();
      }
    });
  }

  @override
  Future<void> unlock({
    required int ckey,
  }) async {
    var connectedDevice = _bluetoothHelper.getConnectedDevice();
    const int uid = 0;
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }

    List<BluetoothService> services = await connectedDevice.discoverServices();

    BluetoothService service = services.firstWhere(
      (s) => s.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Servicio no encontrado.'),
    );

    BluetoothCharacteristic notifyCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de notificación no encontrada.'),
    );

    BluetoothCharacteristic writeCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de escritura no encontrada.'),
    );

    List<int> sendMessage = _scooterCommandHelper.getCRCScooterOpen(
      ckey: ckey,
      mode: 1,
      uid: uid,
      timestamp: timestamp,
    );

    await writeCharacteristic.write(
      sendMessage,
    );
    await notifyCharacteristic.setNotifyValue(
      true,
    );
    notifyCharacteristic.value.listen((
      responseBleDevice,
    ) {
      processReceivedValues(
        dataListValues: responseBleDevice,
      );
    });
  }

  @override
  Future<void> lock({
    required int ckey,
  }) async {
    var connectedDevice = _bluetoothHelper.getConnectedDevice();

    if (connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }

    List<BluetoothService> services = await connectedDevice.discoverServices();

    BluetoothService service = services.firstWhere(
      (s) => s.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Servicio no encontrado.'),
    );

    BluetoothCharacteristic notifyCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de notificación no encontrada.'),
    );

    BluetoothCharacteristic writeCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de escritura no encontrada.'),
    );

    List<int> sendMessage = _scooterCommandHelper.getCRCScooterClose(
      deviceUniqueKey: getDeviceKey,
      ckey: ckey,
    );

    await writeCharacteristic.write(
      sendMessage,
    );
    await notifyCharacteristic.setNotifyValue(
      true,
    );
    notifyCharacteristic.value.listen((
      responseBleDevice,
    ) {
      processReceivedValues(
        dataListValues: responseBleDevice,
      );
    });
  }

  @override
  Future<void> info({
    required int ckey,
  }) async {
    var connectedDevice = _bluetoothHelper.getConnectedDevice();

    if (connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }

    List<BluetoothService> services = await connectedDevice.discoverServices();

    BluetoothService service = services.firstWhere(
      (s) => s.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Servicio no encontrado.'),
    );

    BluetoothCharacteristic notifyCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de notificación no encontrada.'),
    );

    BluetoothCharacteristic writeCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid.toString().toUpperCase() == uuid.toUpperCase(),
      orElse: () => throw Exception('Característica de escritura no encontrada.'),
    );

    List<int> sendMessage = _scooterCommandHelper.getCRCScooterInfo(
      ckey: ckey,
    );

    await writeCharacteristic.write(
      sendMessage,
    );
    await notifyCharacteristic.setNotifyValue(
      true,
    );
    notifyCharacteristic.value.listen((
      responseBleDevice,
    ) async {
      Uint8List? processedValues = await processReceivedValues(
        dataListValues: responseBleDevice,
      );

      if (processedValues != null) {
        List<int> info = onHandInfo(
          responseDevice: processedValues,
        );
        UserConfig().setDeviceInfo(
          responseDeviceInfo: info,
        );
      }
    });
  }

  void dispose() {
    _deviceCommandStreamController.close();
  }
}
