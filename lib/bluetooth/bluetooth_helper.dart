import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/bluetooth/models/device_model.dart';
import 'package:mobi_bt_iot/bluetooth/models/service_model.dart';
import 'package:mobi_bt_iot/bluetooth/bluetooth_interface.dart';

class BluetoothHelper implements BluetoothDeviceInterface {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final _discoveredDevicesStreamController =
      StreamController<List<DeviceModel>>.broadcast();
  final _servicesStreamController =
      StreamController<List<ServiceModel>>.broadcast();
  List<DeviceModel> _discoveredDevices = [];
  BluetoothDevice? _connectedDevice;

  static final BluetoothHelper _instance = BluetoothHelper._internal();

  factory BluetoothHelper() {
    return _instance;
  }

  BluetoothHelper._internal();

  @override
  Stream<List<DeviceModel>> getDiscoveredDevicesStream() =>
      _discoveredDevicesStreamController.stream;

  Stream<List<ServiceModel>> getConnectedDeviceServices() {
    if (_connectedDevice == null) {
      return Stream.value([]);
    } else {
      return _connectedDevice!.discoverServices().then((services) {
        return services
            .map((service) => ServiceModel.fromBluetoothService(service))
            .toList();
      }).asStream();
    }
  }

  @override
  Future<void> startScan() async {
    _discoveredDevices.clear();
    flutterBlue.startScan();
    flutterBlue.scanResults.listen((results) {
      _discoveredDevices = results
          .map((r) => DeviceModel.fromBluetoothDevice(r.device))
          .toList();
      _discoveredDevicesStreamController.add(_discoveredDevices);
    });
  }

  @override
  Future<void> stopScan() async {
    flutterBlue.stopScan();
  }

  void dispose() {
    _discoveredDevicesStreamController.close();
    _servicesStreamController.close();
  }

  @override
  Future<void> connectToDevice(String address) async {
    DeviceModel? targetDevice = _discoveredDevices.firstWhere(
      (d) => d.address == address,
    );

    try {
      await targetDevice.connectState!.connect();
      _connectedDevice = targetDevice.connectState;
    } catch (e) {
      (e);
    }
  }

  @override
  Future<void> disconnectFromDevice(String address) async {
    var device = flutterBlue.connectedDevices.then(
      (devices) => devices.firstWhere((d) => d.id.toString() == address),
    );
    await device.then((d) => d.disconnect());
    if (_connectedDevice?.id.toString() == address) {
      _connectedDevice = null;
      _servicesStreamController.add([]);
    }
  }

  @override
  BluetoothDevice? getConnectedDevice() {
    return _connectedDevice;
  }

  @override
  Stream<List<ServiceModel>> getDeviceServices() {
    if (_connectedDevice == null) {
      _servicesStreamController.add([]);
    } else {
      _connectedDevice!.discoverServices().then((services) {
        _servicesStreamController.add(
          services
              .map((service) => ServiceModel.fromBluetoothService(service))
              .toList(),
        );
      }).catchError((error) {
        _servicesStreamController.addError(error);
      });
    }

    return _servicesStreamController.stream;
  }

  Future<List<BluetoothCharacteristic>> getCharacteristicsForService(
    String serviceUuid,
  ) async {
    if (_connectedDevice == null) {
      throw Exception('No hay ningún dispositivo conectado.');
    }

    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();
    BluetoothService service = services.firstWhere(
      (s) => s.uuid.toString().toUpperCase() == serviceUuid.toUpperCase(),
      orElse: () => throw Exception('Servicio no encontrado.'),
    );

    return service.characteristics;
  }
}
