import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/bluetooth/bluetooth_helper.dart';
import 'package:mobi_bt_iot/iot/config/device_config.dart';
import 'package:mobi_bt_iot/iot/interfaces/device_manager_interface.dart';
import 'package:mobi_bt_iot/iot/utils/ble_utils.dart';
import 'package:mobi_bt_iot/iot/helpers/bluetooth_device_manager.dart';
import 'package:mobi_bt_iot/iot/utils/scooter_utils.dart';

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
    BluetoothService service = await bluetoothServiceManager.getService(
      connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      2,
    );

    List<int> sendMessage = ScooterCommandUtil.getCRCCommunicationKey(
      deviceUniqueKey: DeviceConfig().getDeviceUniqueKey(),
    );
    await bluetoothServiceManager.writeAndNotify(
        writeCharacteristic, notifyCharacteristic, sendMessage, (
      responseBleDevice,
    ) async {
      await processReceivedValues(
        dataListValues: responseBleDevice,
        isInfo: false,
      );
    });
  }

  @override
  Future<void> infoDevice({
    required int ckey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();
    BluetoothService service = await bluetoothServiceManager.getService(
      connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      2,
    );

    List<int> sendMessage = ScooterCommandUtil.getCRCScooterInfo(
      ckey: ckey,
    );
    await bluetoothServiceManager.writeAndNotify(
        writeCharacteristic, notifyCharacteristic, sendMessage, (
      responseBleDevice,
    ) async {
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

  @override
  Future<void> lockDevice({
    required int ckey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();
    BluetoothService service = await bluetoothServiceManager.getService(
      connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      2,
    );

    List<int> sendMessage = ScooterCommandUtil.getCRCScooterClose(
      ckey: ckey,
    );
    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic,
      notifyCharacteristic,
      sendMessage,
      (
        responseBleDevice,
      ) {},
    );
  }

  @override
  Future<void> unlockDevice({
    required int ckey,
  }) async {
    var connectedDevice = await bluetoothServiceManager.getConnectedDevice();
    BluetoothService service = await bluetoothServiceManager.getService(
      connectedDevice,
    );
    BluetoothCharacteristic notifyCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      1,
    );
    BluetoothCharacteristic writeCharacteristic =
        await bluetoothServiceManager.getCharacteristic(
      service,
      2,
    );

    int uid = 0;
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    List<int> sendMessage = ScooterCommandUtil.getCRCScooterOpen(
      ckey: ckey,
      mode: 1,
      uid: uid,
      timestamp: timestamp,
    );
    await bluetoothServiceManager.writeAndNotify(
      writeCharacteristic,
      notifyCharacteristic,
      sendMessage,
      (
        responseBleDevice,
      ) {},
    );
  }
}
