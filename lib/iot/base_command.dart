import 'dart:math';

import 'package:mobi_bt_iot/iot/CrcUtil.dart';
import 'package:mobi_bt_iot/iot/base_command_interface.dart';


class BaseCommand implements BaseCommandInterface{
   @override
  List<int> addBytes(List<int> a, List<int> b) {
    return [...a, ...b];
  }

   @override
  List<int> addSingleByte(List<int> a, int b) {
    return [...a, b];
  }

   @override
  List<int> addInt(List<int> a, int b) {
    List<int> bBytes = [
      (b >> 24) & 0xFF,
      (b >> 16) & 0xFF,
      (b >> 8) & 0xFF,
      b & 0xFF,
    ];
    return addBytes(a, bBytes);
  }

   @override
  List<int> addLong(List<int> a, int b) {
    return addInt(a, b);
  }

   @override
  List<int> getCommand(int ckey, int commandType, List<int> data) {
    List<int> head = [0xA3, 0xA4];
    int len = data.length;
    int rand = Random().nextInt(255) & 0xff;
    List<int> command = addBytes(head, [len, rand, ckey, commandType]);
    return addBytes(command, data);
  }

   @override
  List<int> getXorCRCCommand(List<int> command) {
    List<int> xorCommand = encode(command);
    List<int> crcOrder = crcByte(xorCommand);
    return crcOrder;
  }

   @override
  List<int> encode(List<int> command) {
    List<int> xorComm = List.from(command);
    xorComm[3] = (command[3] + 0x32) & 0xFF;
    for (int i = 4; i < command.length; i++) {
      xorComm[i] = command[i] ^ command[3];
    }
    return xorComm;
  }

   @override
  List<int> crcByte(List<int> ori) {
    List<int> ret = List.from(ori)..add(CRCUtil.calcCRC8(ori));
    return ret;
  }

   @override
  List<int> crcByte2(List<int> ori) {
    List<int> ret = [CRCUtil.calcCRC8(ori), ...ori];
    return ret;
  }
}
