import 'package:flutter_blue/flutter_blue.dart';

class ServiceEntity {
  ServiceEntity({
    required this.uuid,
    required this.deviceId,
    required this.isPrimary,
    required this.characteristics,
    required this.includedServices,
  });

  final String uuid;
  final String deviceId;
  final bool isPrimary;
  final List<BluetoothCharacteristic> characteristics;
  final List<BluetoothService> includedServices;
}
