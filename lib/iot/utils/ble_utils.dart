import 'dart:math';
import 'dart:typed_data';

import 'package:mobi_bt_iot/iot/config/device_config.dart';

import 'crc_util.dart';

Future<Uint8List?> processReceivedValues({
  required List<int> dataListValues,
  required bool ckey,
  required bool info,
  required bool lock,
}) async {
  int start = 0;
  int copyLen = 0;

  for (int i = 0; i < dataListValues.length; i++) {
    if ((dataListValues[i] & 0xFF) == 0xA3 &&
        (dataListValues[i + 1] & 0xFF) == 0xA4) {
      start = i;
      int len = dataListValues[i + 2];
      copyLen = len + 7;
      break;
    }
  }

  if (copyLen == 0) return null;

  Uint8List real = Uint8List.fromList(
    dataListValues.sublist(
      start,
      start + copyLen,
    ),
  );
  Uint8List responseMessage = Uint8List.fromList(
    real.sublist(
      0,
      real.length - 1,
    ),
  );
  int crc8 = CRCUtil.calcCRC8(
    dataList: responseMessage,
  );

  int vCrc = real.last & 0xFF;

  if (crc8 == vCrc) {
    int rand = real[3] - 0x32;
    responseMessage[3] = rand;
    for (int i = 4; i < responseMessage.length; i++) {
      responseMessage[i] = (responseMessage[i] ^ rand) & 0xFF;
    }

    if (ckey == true) {
      onHandNotifyCommand(
        handleResponse: responseMessage,
      );
    }
    if (info == true) {
      List<int> infoHanded = onHandInfo(
        responseDevice: responseMessage,
      );
      DeviceConfig().setDeviceInfo(
        responseDeviceInfo: infoHanded,
      );
      return responseMessage;
    }

    if (lock == true) {
      DeviceConfig().setDeviceLockStatus(
        newDeviceLockStatus: responseMessage[8],
      );
      return responseMessage;
    }

    return responseMessage;
  } else {
    return null;
  }
}

Future<Uint8List?> processReceivedValuesUnlock({
  required List<int> dataListValues,
  required bool ckey,
  required bool info,
  required bool lock,
}) async {
  int start = 0;
  int copyLen = 0;

  for (int i = 0; i < dataListValues.length; i++) {
    if ((dataListValues[i] & 0xFF) == 0xA3 &&
        (dataListValues[i + 1] & 0xFF) == 0xA4) {
      start = i;
      int len = dataListValues[i + 2];
      copyLen = len + 7;
      break;
    }
  }

  if (copyLen == 0) return null;

  Uint8List real = Uint8List.fromList(
    dataListValues.sublist(
      start,
      start + copyLen,
    ),
  );
  Uint8List responseMessage = Uint8List.fromList(
    real.sublist(
      0,
      real.length - 1,
    ),
  );
  int crc8 = CRCUtil.calcCRC8(
    dataList: responseMessage,
  );

  int vCrc = real.last & 0xFF;

  if (crc8 == vCrc) {
    int rand = real[3] - 0x32;
    responseMessage[3] = rand;
    for (int i = 4; i < responseMessage.length; i++) {
      responseMessage[i] = (responseMessage[i] ^ rand) & 0xFF;
    }

    if (ckey == true) {
      onHandNotifyCommand(
        handleResponse: responseMessage,
      );
    }
    if (info == true) {
      List<int> infoHanded = onHandInfo(
        responseDevice: responseMessage,
      );
      DeviceConfig().setDeviceInfo(
        responseDeviceInfo: infoHanded,
      );
      return responseMessage;
    }

    if (lock == true) {
      DeviceConfig().setDeviceLockStatus(
        newDeviceLockStatus: responseMessage[8],
      );
      return responseMessage;
    }

    return responseMessage;
  } else {
    return null;
  }
}

Future<void> onHandNotifyCommand({
  required Uint8List handleResponse,
}) async {
  const int communicationKeyCommand = 0x01;
  const int errorCommand = 0x02;

  switch (handleResponse[5]) {
    case communicationKeyCommand:
      await handCommunicationKey(
        responseMessage: handleResponse,
      );
      break;
    case errorCommand:
      await handCommandError(
        handleError: handleResponse,
      );
      break;
  }
}

Future<void> handCommandError({
  required Uint8List handleError,
}) async {
  int status = handleError[6];
  log(status);
}

Future<void> handCommunicationKey({
  required Uint8List responseMessage,
}) async {
  int flag = responseMessage[6];
  if (flag == 1) {
    DeviceConfig().setDeviceCkey(
      newDeviceCkey: responseMessage[7],
    );
  }
}

List<String> convertToHexWithPrefixUppercase({required List<int> dataIntList}) {
  return dataIntList
      .map(
        (number) =>
            '0x${number.toRadixString(16).toUpperCase().padLeft(2, '0')}',
      )
      .toList();
}

List<int> onHandInfo({
  required List<int> responseDevice,
}) {
  int power = (responseDevice[6] & 0xFF);
  int mode = responseDevice[7] & 0xFF;
  int speed = ((responseDevice[8] & 0xFF) << 8) | (responseDevice[9] & 0xFF);
  int mileage =
      ((responseDevice[10] & 0xFF) << 8) | (responseDevice[11] & 0xFF);

  if (responseDevice.length < 14) return [power, mode, speed, mileage, 0];

  int prescientMileage =
      ((responseDevice[12] & 0xFF) << 8) | (responseDevice[13] & 0xFF);

  return [
    power,
    mode,
    speed,
    mileage,
    prescientMileage,
  ];
}
