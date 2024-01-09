import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:mobi_bt_iot/bluetooth/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  DeviceModel({
    required super.name,
    required super.address,
    super.connectState,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
    };
  }

  factory DeviceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DeviceModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  static DeviceModel fromBluetoothDevice(
    BluetoothDevice device,
  ) {
    return DeviceModel(
      name: device.platformName,
      address: device.remoteId.toString(),
      connectState: device,
    );
  }
}
