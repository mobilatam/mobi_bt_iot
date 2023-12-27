import 'dart:typed_data';

abstract class BleUtilInterface {
  Future<Uint8List?> processReceivedValues({
    required List<int> values,
  });

  Future<void> onHandNotifyCommand({
    required Uint8List command,
  });

  Future<void> handCommandError({
    required Uint8List command,
  });

  Future<void> callbackCommandError({
    required int status,
  });

  Future<void> handCommunicationKey({
    required Uint8List command,
  });

  Future<void> callbackCommunicationKey({
    required int mBLECommunicationKey,
  });

  Future<void> callbackCommunicationKeyError();

  List<String> convertToHexWithPrefixUppercase({
    required List<int> numbers,
  });
}
