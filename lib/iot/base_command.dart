import 'dart:math';

/// todo: revisar que todo este tipado required
/// todo: revisar trailing commas
/// todo: constructor primero, finales despues
/// todo: orden de las carpetas
/// todo: manejador de errores

import 'package:mobi_bt_iot/iot/CrcUtil.dart';
import 'package:mobi_bt_iot/iot/base_command_interface.dart';

class BaseCommand implements BaseCommandInterface {
  @override
  List<int> addBytes({
    required List<int> a,
    required List<int> b,
  }) {
    return [
      ...a,
      ...b,
    ];
  }

  @override
  List<int> addSingleByte({
    required List<int> a,
    required int b,
  }) {
    return [
      ...a,
      b,
    ];
  }

  @override
  List<int> addInt({
    required List<int> a,
    required int b,
  }) {
    List<int> bBytes = [
      (b >> 24) & 0xFF,
      (b >> 16) & 0xFF,
      (b >> 8) & 0xFF,
      b & 0xFF,
    ];
    return addBytes(
      a: a,
      b: bBytes,
    );
  }

  @override
  List<int> addLong({
    required List<int> a,
    required int b,
  }) {
    return addInt(
      a: a,
      b: b,
    );
  }

  @override
  List<int> getCommand({
    required int ckey,
    required int commandType,
    required List<int> data,
  }) {
    List<int> head = [0xA3, 0xA4];
    int len = data.length;
    int rand = Random().nextInt(255) & 0xff;
    List<int> command = addBytes(a: head, b: [len, rand, ckey, commandType]);
    return addBytes(
      a: command,
      b: data,
    );
  }

  @override
  List<int> getXorCRCCommand({
    required List<int> command,
  }) {
    List<int> xorCommand = encode(command: command);
    List<int> crcOrder = crcByte(ori: xorCommand);
    return crcOrder;
  }

  @override
  List<int> encode({
    required List<int> command,
  }) {
    List<int> xorComm = List.from(command);
    xorComm[3] = (command[3] + 0x32) & 0xFF;
    for (int i = 4; i < command.length; i++) {
      xorComm[i] = command[i] ^ command[3];
    }
    return xorComm;
  }

  @override
  List<int> crcByte({
    required List<int> ori,
  }) {
    List<int> ret = List.from(ori)
      ..add(
        CRCUtil.calcCRC8(ori),
      );
    return ret;
  }

  @override
  List<int> crcByte2({
    required List<int> ori,
  }) {
    List<int> ret = [
      CRCUtil.calcCRC8(ori),
      ...ori,
    ];
    return ret;
  }
}
