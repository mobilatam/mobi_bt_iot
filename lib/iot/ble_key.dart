import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../bluetooth/bluetooth_helper.dart';
import 'CrcUtil.dart';
import 'scooter_command_helper.dart';

class DeviceKeyManager {
  DeviceKeyManager({
    required this.bluetoothHelper,
  });
  ScooterCommandHelper scooterCommandUtil = ScooterCommandHelper();
  final BluetoothHelper bluetoothHelper;

  int mBLECommunicationKey = 0;

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

    List<int> message = scooterCommandUtil.getCRCCommunicationKey('yOTmK50z');

    print('message send: $convertToHexWithPrefixUppercase(message)');

    await writeCharacteristic.write(message, withoutResponse: false);
    await notifyCharacteristic.setNotifyValue(true);
    notifyCharacteristic.value.listen((values) {
      print("Received values: $convertToHexWithPrefixUppercase(values)");

      int start = 0;
      int copyLen = 0;

      for (int i = 0; i < values.length; i++) {
        if ((values[i] & 0xFF) == 0xA3 && (values[i + 1] & 0xFF) == 0xA4) {
          start = i;
          int len = values[i + 2];
          copyLen = len + 7;
          break;
        }
      }

      if (copyLen == 0) return;
      Uint8List real = Uint8List.fromList(values.sublist(start, start + copyLen));

      Uint8List command = Uint8List.fromList(real.sublist(0, real.length - 1));
      int crc8 = CRCUtil.calcCRC8(command);
      print('crc8: $crc8');

      int vCrc = real.last & 0xFF;

      print('vCrc: $vCrc');

      if (crc8 == vCrc) {
        int rand = real[3] - 0x32;
        command[3] = rand;
        for (int i = 4; i < command.length; i++) {
          command[i] = (command[i] ^ rand) & 0xFF;
        }
        print('command: ${convertToHexWithPrefixUppercase(command)}');
        onHandNotifyCommand(command);
      } else {
        print("CRC8 validation failed");
      }
    });
  }

  Future<void> onHandNotifyCommand(Uint8List command) async {
    const int communicationKeyCommand = 0x01;
    const int errorCommand = 0x02;

    switch (command[5]) {
      case communicationKeyCommand:
        await handCommunicationKey(command);
        break;
      case errorCommand:
        await handCommandError(command);
        break;
      default:
        print("onHandNotifyCommand  ${command[5]} : Unknown command");
        await handCommandError(command);
        break;
    }
  }

  Future<void> handCommandError(Uint8List command) async {
    print("handCommandError: Command failed");
    int status = command[6];
    await callbackCommandError(status);
  }

  Future<void> callbackCommandError(int status) async {
    print("Error status: $status");
  }

  Future<void> handCommunicationKey(Uint8List command) async {
    int flag = command[6];
    if (flag == 1) {
      mBLECommunicationKey = command[7];
      await callbackCommunicationKey(mBLECommunicationKey);
    } else {
      await callbackCommunicationKeyError();
      print("handCommunicationKey: Failed to get communication key");
    }
  }

  Future<void> callbackCommunicationKey(int communicationKey) async {
    /// todo: return value to add to user config
    print("Received communication key $communicationKey");
  }

  Future<void> callbackCommunicationKeyError() async {
    print("Failed to get communication key");
  }

  List<String> convertToHexWithPrefixUppercase(List<int> numbers) {
    return numbers.map((number) => '0x${number.toRadixString(16).toUpperCase().padLeft(2, '0')}').toList();
  }
}
