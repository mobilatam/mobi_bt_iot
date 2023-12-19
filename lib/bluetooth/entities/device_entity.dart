import 'package:flutter_blue/flutter_blue.dart';

class DeviceEntity {
  const DeviceEntity({
    required this.name,
    required this.address,
    required this.type,
    this.connectState,
  });

  final String name;
  final String address;
  final int type;
  final BluetoothDevice? connectState;
}
