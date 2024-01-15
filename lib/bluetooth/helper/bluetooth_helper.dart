import 'dart:async';

import 'package:mobi_bt_iot/mobi_bt_iot.dart';

class BluetoothHelper implements BluetoothDeviceInterface {
  factory BluetoothHelper() {
    return _instance;
  }

  static final BluetoothHelper _instance = BluetoothHelper._internal();

  final _discoveredDevicesStreamController =
      StreamController<List<DeviceModel>>.broadcast();
  final _servicesStreamController =
      StreamController<List<ServiceModel>>.broadcast();
  List<DeviceModel> _discoveredDevices = [];

  BluetoothDevice? _connectedDevice;

  BluetoothHelper._internal();

  @override
  Future<void> connectToDevice({
    required String address,
  }) async {
    DeviceModel? targetDevice = _discoveredDevices.firstWhere(
      (
        d,
      ) =>
          d.address == address,
    );

    try {
      await targetDevice.connectState!.connect();
      _connectedDevice = targetDevice.connectState;
    } catch (error) {
      (error);
    }
  }

  @override
  Future<void> disconnectFromDevice({
    required String address,
  }) async {
    List<BluetoothDevice> devices = FlutterBluePlus.connectedDevices;
    BluetoothDevice device = devices.firstWhere(
      (d) => d.remoteId.toString() == address,
    );
    await device.disconnect();
    if (_connectedDevice?.remoteId.toString() == address) {
      _connectedDevice = null;
      _servicesStreamController.add(
        [],
      );
    }
  }

  void dispose() {
    _discoveredDevicesStreamController.close();
    _servicesStreamController.close();
  }

  Future<List<BluetoothCharacteristic>> getCharacteristicsForService(
    String serviceUuid,
  ) async {
    if (_connectedDevice == null) {
      throw Exception();
    }

    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();
    BluetoothService service = services.firstWhere(
      (s) => s.uuid.toString().toUpperCase() == serviceUuid.toUpperCase(),
      orElse: () => throw Exception(),
    );

    return service.characteristics;
  }

  @override
  BluetoothDevice? getConnectedDevice() {
    return _connectedDevice;
  }

  Stream<List<ServiceModel>> getConnectedDeviceServices() {
    if (_connectedDevice == null) {
      return Stream.value(
        [],
      );
    } else {
      return _connectedDevice!.discoverServices().then((
        services,
      ) {
        return services
            .map(
              (
                service,
              ) =>
                  ServiceModel.fromBluetoothService(
                service,
              ),
            )
            .toList();
      }).asStream();
    }
  }

  @override
  Stream<List<ServiceModel>> getDeviceServices() {
    if (_connectedDevice == null) {
      _servicesStreamController.add(
        [],
      );
    } else {
      _connectedDevice!.discoverServices().then((
        services,
      ) {
        _servicesStreamController.add(
          services
              .map(
                (
                  service,
                ) =>
                    ServiceModel.fromBluetoothService(
                  service,
                ),
              )
              .toList(),
        );
      }).catchError((
        error,
      ) {
        _servicesStreamController.addError(
          error,
        );
      });
    }

    return _servicesStreamController.stream;
  }

  @override
  Stream<List<DeviceModel>> getDiscoveredDevicesStream() =>
      _discoveredDevicesStreamController.stream;

  @override
  Future<void> startScan() async {
    _discoveredDevices.clear();
    FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((
      results,
    ) {
      _discoveredDevices = results
          .map(
            (r) => DeviceModel.fromBluetoothDevice(
              r.device,
            ),
          )
          .toList();
      _discoveredDevicesStreamController.add(
        _discoveredDevices,
      );
    });
  }

  @override
  Future<void> stopScan() async {
    FlutterBluePlus.stopScan();
  }
}
