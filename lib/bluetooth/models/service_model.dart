import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:mobi_bt_iot/bluetooth/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required super.uuid,
    required super.deviceId,
    required super.isPrimary,
    required super.characteristics,
    required super.includedServices,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'deviceId': deviceId,
      'isPrimary': isPrimary,
      'characteristics': characteristics
          .map(
            (c) => c.uuid.toString(),
          )
          .toList(),
      'includedServices': includedServices
          .map(
            (s) => s.uuid.toString(),
          )
          .toList(),
    };
  }

  factory ServiceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ServiceModel(
      uuid: json['uuid'] ?? '',
      deviceId: json['deviceId'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      characteristics: [],
      includedServices: [],
    );
  }

  static ServiceModel fromBluetoothService(
    BluetoothService service,
  ) {
    return ServiceModel(
      uuid: service.uuid.toString(),
      deviceId: service.deviceId.toString(),
      isPrimary: service.isPrimary,
      characteristics: service.characteristics,
      includedServices: service.includedServices,
    );
  }
}
