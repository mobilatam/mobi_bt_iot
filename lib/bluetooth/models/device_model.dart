import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/bluetooth/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  DeviceModel({
    required String name,
    required String address,
    required int type,
    BluetoothDevice? connectState,
  }) : super(
          name: name,
          address: address,
          type: type,
          connectState: connectState,
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'type': type,
    };
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      type: json['type'] ?? 0,
    );
  }

  static DeviceModel fromBluetoothDevice(BluetoothDevice device) {
    return DeviceModel(
      name: device.name ?? '',
      address: device.id.toString(),
      type: device.type.index,
      connectState: device,
    );
  }
}
