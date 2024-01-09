import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceEntity {
  const DeviceEntity({
    required this.name,
    required this.address,
    this.connectState,
  });

  final String name;
  final String address;
  final BluetoothDevice? connectState;
}
