import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:mobi_bt_iot/iot/constants/command_type.dart';
import 'package:mobi_bt_iot/iot/interfaces/iot_scooter_interface.dart';
import 'package:mobi_bt_iot/iot/utils/crc_util.dart';

// class ScooterCommandHelper implements IotScooterInterface {
//   static const String tag = 'ScooterCommandHelper';
//
//
//   List<int> getCommand(int ckey, int commandType, List<int> data) {
//     List<int> head = [0xA3, 0xA4].map((val) => val.toSigned(8)).toList();
//     int len = data.length;
//     int rand = Random().nextInt(256) - 127;
//     List<int> command = addBytes(head, [
//       len,
//       rand,
//       ckey,
//       commandType,
//     ]);
//     return addBytes(command, data);
//   }
//   List<int> getCRCCommunicationKey(String deviceKey) {
//     List<int> data = List.filled(8, 0);
//     for (int i = 0; i < deviceKey.length; i++) {
//       data[i] = deviceKey.codeUnitAt(i);
//     }
//     List<int> command = getCommand(
//       0,
//       CommandType.communicationKey,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   List<int> getCRCScooterOpen(
//     int ckey,
//     int uid,
//     int timestamp,
//   ) {
//     List<int> data = [0x01];
//     data = addBytes(data, intToBytes(uid));
//     data = addBytes(data, intToBytes(timestamp));
//     data = addBytes(data, [0x0]);
//     List<int> command = getCommand(
//       ckey,
//       CommandType.scooterOpen,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   List<int> getCRCScooterOpenResponse(
//     int ckey,
//   ) {
//     List<int> data = [0x02];
//     List<int> command = getCommand(
//       ckey,
//       CommandType.scooterOpen,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> getCRCScooterClose(int ckey) {
//     List<int> data = [0x01];
//     List<int> command = getCommand(
//       ckey,
//       CommandType.scooterClose,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> getCRCScooterCloseResponse(int ckey) {
//     List<int> data = [0x02];
//     List<int> command = getCommand(
//       ckey,
//       CommandType.scooterClose,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> getCRCShutDown(int cKey, int opt) {
//     List<int> data = [0, opt];
//     List<int> command = getCommand(
//       cKey,
//       CommandType.config,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> getCRCScooterIotInfo(int ckey) {
//     List<int> data = [0x01];
//     List<int> command = getCommand(
//       ckey,
//       CommandType.scooterIotInfo,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> getCRCScooterInfo(int ckey) {
//     List<int> data = [0x01];
//     List<int> command = getCommand(
//       ckey,
//       CommandType.scooterInfo,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> getCRCGetOldData(int cKey) {
//     List<int> data = [0x01];
//     List<int> command = getCommand(
//       cKey,
//       CommandType.oldData,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> getCRCClearOldData(int cKey) {
//     List<int> data = [0x01];
//     List<int> command = getCommand(
//       cKey,
//       CommandType.clearData,
//       data,
//     );
//     return getXorCRCCommand(command);
//   }
//
//   @override
//   List<int> addBytes(List<int> a, List<int> b) {
//     return [...a, ...b];
//   }
//
//   @override
//   List<int> intToBytes(int number) {
//     return [
//       (number >> 24) & 0xFF,
//       (number >> 16) & 0xFF,
//       (number >> 8) & 0xFF,
//       number & 0xFF,
//     ];
//   }
//
//   @override
//   List<int> getXorCRCCommand(List<int> command) {
//     List<int> xorCommand = encode(command);
//     List<int> crcOrder = crcByte(xorCommand);
//     return crcOrder;
//   }
//
//   @override
//   List<int> encode(List<int> command) {
//     List<int> xorComm = List<int>.filled(command.length, 0);
//
//     xorComm[0] = command[0];
//     xorComm[1] = command[1];
//     xorComm[2] = command[2];
//     xorComm[3] = (command[3] + 0x32);
//
//     for (int i = 4; i < command.length; i++) {
//       xorComm[i] = (command[i] ^ command[3]);
//     }
//     return xorComm;
//   }
//
//   @override
//   List<int> crcByte(List<int> ori) {
//     int crc8 = CRCUtil.calcCRC8(Uint8List.fromList(ori));
//     List<int> ret = List<int>.from(ori)..add(crc8 & 0xFF);
//     return ret;
//   }
// }

class ScooterCommandHelper implements IotScooterInterface {
  static final ScooterCommandHelper _instance =
      ScooterCommandHelper._internal();

  factory ScooterCommandHelper() {
    return _instance;
  }

  ScooterCommandHelper._internal();

  final StreamController<List<int>> _scooterCommandStreamController =
      StreamController<List<int>>.broadcast();

  Stream<List<int>> get scooterCommandStream =>
      _scooterCommandStreamController.stream;

  @override
  List<int> getCommand({
    required int ckey,
    required int commandType,
    required List<int> stringToInt,
  }) {
    List<int> head = [0xA3, 0xA4]
        .map(
          (val) => val.toSigned(8),
        )
        .toList();
    int len = stringToInt.length;
    int rand = Random().nextInt(256) - 127;
    List<int> command = addBytes(
      a: head,
      b: [
        len,
        rand,
        ckey,
        commandType,
      ],
    );
    return addBytes(
      a: command,
      b: stringToInt,
    );
  }

  @override
  List<int> getCRCCommunicationKey({
    required String deviceKey,
  }) {
    List<int> data = List.filled(
      8,
      0,
    );
    for (int i = 0; i < deviceKey.length; i++) {
      data[i] = deviceKey.codeUnitAt(i);
    }
    List<int> command = getCommand(
      ckey: 0,
      commandType: CommandType.communicationKey,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCScooterOpen({
    required int ckey,
    required int mode,
    required int uid,
    required int timestamp,
  }) {
    List<int> data = [mode];
    data = addBytes(
      a: data,
      b: intToBytes(
        number: uid,
      ),
    );
    data = addBytes(
      a: data,
      b: intToBytes(
        number: timestamp,
      ),
    );
    data.add(
      0x0,
    );
    List<int> command = getCommand(
      ckey: 0,
      commandType: CommandType.communicationKey,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCScooterOpenResponse({
    required int ckey,
  }) {
    List<int> data = [0x02];
    List<int> command = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterOpen,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCScooterClose({
    required int ckey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> command = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterClose,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCScooterCloseResponse({
    required int ckey,
  }) {
    List<int> data = [
      0x02,
    ];
    List<int> command = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterClose,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCShutDown({
    required int cKey,
    required int opt,
  }) {
    List<int> data = [
      0,
      opt,
    ];
    List<int> command = getCommand(
      ckey: cKey,
      commandType: CommandType.config,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCScooterIotInfo({
    required int ckey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> command = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterIotInfo,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCScooterInfo({
    required int ckey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> command = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterInfo,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCGetOldData({
    required int cKey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> command = getCommand(
      ckey: cKey,
      commandType: CommandType.oldData,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

  @override
  List<int> getCRCClearOldData({
    required int cKey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> command = getCommand(
      ckey: cKey,
      commandType: CommandType.clearData,
      stringToInt: data,
    );
    return getXorCRCCommand(
      command: command,
    );
  }

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
  List<int> intToBytes({
    required int number,
  }) {
    return [
      (number >> 24) & 0xFF,
      (number >> 16) & 0xFF,
      (number >> 8) & 0xFF,
      number & 0xFF,
    ];
  }

  @override
  List<int> getXorCRCCommand({
    required List<int> command,
  }) {
    List<int> xorCommand = encode(
      command: command,
    );
    List<int> crcOrder = crcByte(
      ori: xorCommand,
    );
    return crcOrder;
  }

  @override
  List<int> encode({
    required List<int> command,
  }) {
    List<int> xorComm = List<int>.filled(
      command.length,
      0,
    );

    xorComm[0] = command[0];
    xorComm[1] = command[1];
    xorComm[2] = command[2];
    xorComm[3] = (command[3] + 0x32);

    for (int i = 4; i < command.length; i++) {
      xorComm[i] = (command[i] ^ command[3]);
    }
    return xorComm;
  }

  @override
  List<int> crcByte({
    required List<int> ori,
  }) {
    int crc8 = CRCUtil.calcCRC8(
      Uint8List.fromList(
        ori,
      ),
    );
    List<int> ret = List<int>.from(
      ori,
    )..add(
        crc8 & 0xFF,
      );
    return ret;
  }

  void dispose() {
    _scooterCommandStreamController.close();
  }
}
