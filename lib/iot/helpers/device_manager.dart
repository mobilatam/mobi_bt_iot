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
    // String uuid = services.last.uuid.toString().toUpperCase();
    // String notify =
    //     services.last.characteristics[1].uuid.toString().toUpperCase();
    // String write = services.last.characteristics[0].uuid.toString().toUpperCase();

    String uuid = '6E400001-B5A3-F393-E0A9-E50E24DCCA9E';
    String notify = '6E400003-B5A3-F393-E0A9-E50E24DCCA9E';
    String write = '6E400002-B5A3-F393-E0A9-E50E24DCCA9E';
    print('BLE -> uuid-> $uuid');
    print('BLE -> notify-> $notify');
    print('BLE -> write-> $write');
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
          ckey: true,
          info: false,
          lock: false,
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
        await processReceivedValues(
          dataListValues: responseBleDevice,
          ckey: false,
          info: true,
          lock: false,
        );
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
        await processReceivedValuesUnlock(
          dataListValues: responseBleDevice,
          ckey: false,
          info: false,
          lock: true,
        );
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
