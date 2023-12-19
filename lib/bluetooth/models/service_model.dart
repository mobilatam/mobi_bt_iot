import 'package:flutter_blue/flutter_blue.dart';
import 'package:mobi_bt_iot/bluetooth/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required String uuid,
    required String deviceId,
    required bool isPrimary,
    required List<BluetoothCharacteristic> characteristics,
    required List<BluetoothService> includedServices,
  }) : super(
          uuid: uuid,
          deviceId: deviceId,
          isPrimary: isPrimary,
          characteristics: characteristics,
          includedServices: includedServices,
        );

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'deviceId': deviceId,
      'isPrimary': isPrimary,
      'characteristics': characteristics.map((c) => c.uuid.toString()).toList(),
      'includedServices':
          includedServices.map((s) => s.uuid.toString()).toList(),
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      uuid: json['uuid'] ?? '',
      deviceId: json['deviceId'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      characteristics: [],
      includedServices: [],
    );
  }

  static ServiceModel fromBluetoothService(BluetoothService service) {
    return ServiceModel(
      uuid: service.uuid.toString(),
      deviceId: service.deviceId.toString(),
      isPrimary: service.isPrimary,
      characteristics: service.characteristics,
      includedServices: service.includedServices,
    );
  }
}
