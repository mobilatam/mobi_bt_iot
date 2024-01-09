import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/bluetooth/bluetooth_helper.dart';
import 'package:mobi_bt_iot/device_config.dart';
import 'package:mobi_bt_iot/iot/utils/ble_utils.dart';
import 'package:mobi_bt_iot/iot/utils/scooter_utils.dart';

class DeviceManagerSecondVersion {
  DeviceManagerSecondVersion({
    required this.bluetoothHelper,
  });

  final BluetoothHelper bluetoothHelper;
  final DeviceConfig deviceConfig = DeviceConfig();
  StreamSubscription? _notifySubscription;

  Future<BluetoothDevice> _getConnectedDevice() async {
    var connectedDevice = bluetoothHelper.getConnectedDevice();
    if (connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }
    return connectedDevice;
  }

  Future<BluetoothService> _getService(
    BluetoothDevice device,
  ) async {
    List<BluetoothService> services = await device.discoverServices();
    return services.firstWhere(
      (s) =>
          s.uuid.toString().toUpperCase() == deviceConfig.getDeviceListUid()[0],
      orElse: () => throw Exception('Servicio no encontrado.'),
    );
  }

  Future<BluetoothCharacteristic> _getCharacteristic(
    BluetoothService service,
    int characteristicIndex,
  ) async {
    return service.characteristics.firstWhere(
      (c) =>
          c.uuid.toString().toUpperCase() ==
          deviceConfig.getDeviceListUid()[characteristicIndex],
      orElse: () => throw Exception('Característica no encontrada.'),
    );
  }

  Future<void> _writeAndNotify(
    BluetoothCharacteristic writeCharacteristic,
    BluetoothCharacteristic notifyCharacteristic,
    List<int> message,
    Function(
      List<int>,
    ) onResponse,
  ) async {
    await writeCharacteristic.write(
      message,
    );
    await notifyCharacteristic.setNotifyValue(
      true,
    );
    _unsubscribeNotify();
    _notifySubscription = notifyCharacteristic.value.listen((
      responseBleDevice,
    ) {
      onResponse(
        responseBleDevice,
      );
    });
  }

  void _unsubscribeNotify() {
    _notifySubscription?.cancel();
    _notifySubscription = null;
  }

  Future<void> getUuidCommunication() async {
    var connectedDevice = await _getConnectedDevice();

    List<BluetoothService> services = await connectedDevice.discoverServices();
    String uuid = services[2].uuid.toString().toUpperCase();
    String notify =
        services[2].characteristics[0].uuid.toString().toUpperCase();
    String write = services[2].characteristics[1].uuid.toString().toUpperCase();

    if (uuid.isNotEmpty && notify.isNotEmpty && write.isNotEmpty) {
      deviceConfig.setDeviceListUid(
        newDeviceListUid: [
          uuid,
          notify,
          write,
        ],
      );
    }
  }

  Future<void> getCkey({
    required String deviceKey,
  }) async {
    await getUuidCommunication();
    var connectedDevice = await _getConnectedDevice();
    BluetoothService service = await _getService(connectedDevice);
    BluetoothCharacteristic notifyCharacteristic =
        await _getCharacteristic(service, 1);
    BluetoothCharacteristic writeCharacteristic =
        await _getCharacteristic(service, 2);

    List<int> sendMessage = ScooterCommandUtil.getCRCCommunicationKey(
      deviceUniqueKey: DeviceConfig().getDeviceUniqueKey(),
    );

    await _writeAndNotify(
        writeCharacteristic, notifyCharacteristic, sendMessage, (
      responseBleDevice,
    ) async {
      await processReceivedValues(
        dataListValues: responseBleDevice,
        isInfo: false,
      );
    });
  }

  Future<void> infoDevice({
    required int ckey,
  }) async {
    var connectedDevice = await _getConnectedDevice();
    BluetoothService service = await _getService(connectedDevice);
    BluetoothCharacteristic notifyCharacteristic =
        await _getCharacteristic(service, 1);
    BluetoothCharacteristic writeCharacteristic =
        await _getCharacteristic(service, 2);

    List<int> sendMessage = ScooterCommandUtil.getCRCScooterInfo(
      ckey: ckey,
    );

    await _writeAndNotify(
        writeCharacteristic, notifyCharacteristic, sendMessage,
        (responseBleDevice) async {
      Uint8List? processedValues = await processReceivedValues(
        dataListValues: responseBleDevice,
        isInfo: true,
      );

      if (processedValues != null) {
        List<int> info = onHandInfo(
          responseDevice: processedValues,
        );
        deviceConfig.setDeviceInfo(
          responseDeviceInfo: info,
        );
      }
    });
  }

  Future<void> lockDevice({required int ckey}) async {
    var connectedDevice = await _getConnectedDevice();
    BluetoothService service = await _getService(connectedDevice);
    BluetoothCharacteristic notifyCharacteristic =
        await _getCharacteristic(service, 1);
    BluetoothCharacteristic writeCharacteristic =
        await _getCharacteristic(service, 2);

    List<int> sendMessage = ScooterCommandUtil.getCRCScooterClose(ckey: ckey);

    await _writeAndNotify(
      writeCharacteristic,
      notifyCharacteristic,
      sendMessage,
      (responseBleDevice) {},
    );
  }

  Future<void> unlockDevice({required int ckey}) async {
    var connectedDevice = await _getConnectedDevice();
    BluetoothService service = await _getService(connectedDevice);
    BluetoothCharacteristic notifyCharacteristic =
        await _getCharacteristic(service, 1);
    BluetoothCharacteristic writeCharacteristic =
        await _getCharacteristic(service, 2);

    int uid = 0;
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    List<int> sendMessage = ScooterCommandUtil.getCRCScooterOpen(
      ckey: ckey,
      mode: 1,
      uid: uid,
      timestamp: timestamp,
    );

    await _writeAndNotify(
      writeCharacteristic,
      notifyCharacteristic,
      sendMessage,
      (responseBleDevice) {},
    );
  }
}
