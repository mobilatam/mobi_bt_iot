import 'dart:typed_data';

import 'package:mobi_bt_iot/mobi_bt_iot.dart';

class DeviceManager implements DeviceManagerInterface {
  DeviceManager({
    required this.bluetoothHelper,
  }) : bluetoothServiceManager = BluetoothServiceManager(
          bluetoothHelper: bluetoothHelper,
        );

  final BluetoothHelper bluetoothHelper;
  final DeviceConfig deviceConfig = DeviceConfig();
  final BluetoothServiceManager bluetoothServiceManager;

  @override
  Future<void> getUuidCommunication() async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();
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

  @override
  Future<void> getCkey({
    required String deviceKey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();

    List<int> sendMessage = ScooterCommandUtil.getCRCCommunicationKey(
      deviceUniqueKey: DeviceConfig().getDeviceUniqueKey(),
    );

    BluetoothService service = await bluetoothServiceManager.getService(
      device: connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 2,
    );

    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic: writeCharacteristic,
      notifyCharacteristic: notifyCharacteristic,
      message: sendMessage,
      onResponse: (
        responseBleDevice,
      ) async {
        await processReceivedValues(
          dataListValues: responseBleDevice,
          isInfo: false,
        );
        return;
      },
    );
  }

  @override
  Future<void> infoDevice({
    required int ckey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();
    List<int> sendMessage = ScooterCommandUtil.getCRCScooterInfo(
      ckey: ckey,
    );
    BluetoothService service = await bluetoothServiceManager.getService(
      device: connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 2,
    );

    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic: writeCharacteristic,
      notifyCharacteristic: notifyCharacteristic,
      message: sendMessage,
      onResponse: (
        responseBleDevice,
      ) async {
        Uint8List? processedValues = await processReceivedValues(
          dataListValues: responseBleDevice,
          isInfo: true,
        );
        if (processedValues != null) {
          deviceConfig.setDeviceInfo(
            responseDeviceInfo: processedValues,
          );
        }
        return;
      },
    );
  }

  @override
  Future<void> lockInfo({
    required int ckey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();
    List<int> sendMessage = ScooterCommandUtil.getCRCScooterIotInfo(
      ckey: ckey,
    );
    BluetoothService service = await bluetoothServiceManager.getService(
      device: connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 2,
    );

    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic: writeCharacteristic,
      notifyCharacteristic: notifyCharacteristic,
      message: sendMessage,
      onResponse: (
        responseBleDevice,
      ) async {
        Uint8List? processedValues = await processReceivedValues(
          dataListValues: responseBleDevice,
          isInfo: true,
        );

        if (processedValues != null) {
          deviceConfig.setDeviceLockStatus(
            newDeviceLockStatus: processedValues[8],
          );
        }
        return;
      },
    );
  }

  @override
  Future<void> lockDevice({
    required int ckey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();

    List<int> sendMessage = ScooterCommandUtil.getCRCScooterClose(
      ckey: ckey,
    );

    BluetoothService service = await bluetoothServiceManager.getService(
      device: connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 2,
    );

    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic: writeCharacteristic,
      notifyCharacteristic: notifyCharacteristic,
      message: sendMessage,
      onResponse: (
        responseBleDevice,
      ) async {
        return;
      },
    );
  }

  @override
  Future<void> unlockDevice({
    required int ckey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();
    int uid = 0;
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    List<int> sendMessage = ScooterCommandUtil.getCRCScooterOpen(
      ckey: ckey,
      mode: 1,
      uid: uid,
      timestamp: timestamp,
    );
    BluetoothService service = await bluetoothServiceManager.getService(
      device: connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 2,
    );

    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic: writeCharacteristic,
      notifyCharacteristic: notifyCharacteristic,
      message: sendMessage,
      onResponse: (
        responseBleDevice,
      ) async {
        return;
      },
    );
  }

  @override
  Future<void> setScooter({
    required int ckey,
    required int velocity,
    required int headLight,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();

    List<int> sendMessage = ScooterCommandUtil.setScooter(
      ckey: ckey,
      velocity: velocity,
      headLight: headLight,
    );
    BluetoothService service = await bluetoothServiceManager.getService(
      device: connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service: service,
      characteristicIndex: 2,
    );

    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic: writeCharacteristic,
      notifyCharacteristic: notifyCharacteristic,
      message: sendMessage,
      onResponse: (
        responseBleDevice,
      ) async {
        return;
      },
    );
  }
}
