import 'dart:typed_data';

import 'CrcUtil.dart';

Future<Uint8List?> processReceivedValues(List<int> values) async {
  int start = 0;
  int copyLen = 0;

  for (int i = 0; i < values.length; i++) {
    if ((values[i] & 0xFF) == 0xA3 && (values[i + 1] & 0xFF) == 0xA4) {
      start = i;
      int len = values[i + 2];
      copyLen = len + 7;
      break;
    }
  }

  if (copyLen == 0) return null;

  Uint8List real = Uint8List.fromList(values.sublist(start, start + copyLen));
  Uint8List command = Uint8List.fromList(real.sublist(0, real.length - 1));
  int crc8 = CRCUtil.calcCRC8(command);

  int vCrc = real.last & 0xFF;

  if (crc8 == vCrc) {
    int rand = real[3] - 0x32;
    command[3] = rand;
    for (int i = 4; i < command.length; i++) {
      command[i] = (command[i] ^ rand) & 0xFF;
    }
    return command;
  } else {
    return null;
  }
}

Future<void> onHandNotifyCommand({required Uint8List command}) async {
  const int communicationKeyCommand = 0x01;
  const int errorCommand = 0x02;

  switch (command[5]) {
    case communicationKeyCommand:
      await handCommunicationKey(command);
      break;
    case errorCommand:
      await handCommandError(command);
      break;
    default:
      await handCommandError(command);
      break;
  }
}

Future<void> handCommandError(Uint8List command) async {
  int status = command[6];
  await callbackCommandError(status);
}

Future<void> callbackCommandError(int status) async {}

Future<void> handCommunicationKey(Uint8List command) async {
  int flag = command[6];
  if (flag == 1) {
    int mBLECommunicationKey = command[7];
    await callbackCommunicationKey(mBLECommunicationKey);
  } else {
    await callbackCommunicationKeyError();
  }
}

Future<void> callbackCommunicationKey(int mBLECommunicationKey) async {
  DeviceConfig().setKey(mBLECommunicationKey);
}

Future<void> callbackCommunicationKeyError() async {}

List<String> convertToHexWithPrefixUppercase(List<int> numbers) {
  return numbers
      .map(
        (number) =>
    '0x${number.toRadixString(16).toUpperCase().padLeft(2, '0')}',
  )
      .toList();
}