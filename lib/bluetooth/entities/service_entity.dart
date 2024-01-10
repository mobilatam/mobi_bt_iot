import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
