import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:mobi_bt_iot/iot/comand.dart';
import 'package:mobi_bt_iot/iot/CrcUtil.dart';
import 'package:mobi_bt_iot/iot/iot_scooter_interface.dart';


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
  static final ScooterCommandHelper _instance = ScooterCommandHelper._internal();

  factory ScooterCommandHelper() {
    return _instance;
  }

  ScooterCommandHelper._internal();

  final StreamController<List<int>> _scooterCommandStreamController =
  StreamController<List<int>>.broadcast();

  Stream<List<int>> get scooterCommandStream =>
      _scooterCommandStreamController.stream;

  List<int> getCommand() {
    List<int> head = [0xA3, 0xA4].map((val) => val.toSigned(8)).toList();
    int len = data.length;
    int rand = Random().nextInt(256) - 127;
    List<int> command = addBytes(head, [
      len,
      rand,
      ckey,
      commandType,
    ]);
    return addBytes(command, data);
  }

  List<int> getCRCCommunicationKey(String deviceKey) {
    List<int> data = List.filled(8, 0);
    for (int i = 0; i < deviceKey.length; i++) {
      data[i] = deviceKey.codeUnitAt(i);
    }
    List<int> command = getCommand(
      0,
      CommandType.communicationKey,
      data,
    );
    return getXorCRCCommand(command);
  }

  List<int> getCRCScooterOpen(
      int ckey,
      int uid,
      int timestamp,
      ) {
    List<int> data = [0x01];
    data = addBytes(data, intToBytes(uid));
    data = addBytes(data, intToBytes(timestamp));
    data = addBytes(data, [0x0]);
    List<int> command = getCommand(
      ckey,
      CommandType.scooterOpen,
      data,
    );
    return getXorCRCCommand(command);
  }

  List<int> getCRCScooterOpenResponse(
      int ckey,
      ) {
    List<int> data = [0x02];
    List<int> command = getCommand(
      ckey,
      CommandType.scooterOpen,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> getCRCScooterClose(int ckey) {
    List<int> data = [0x01];
    List<int> command = getCommand(
      ckey,
      CommandType.scooterClose,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> getCRCScooterCloseResponse(int ckey) {
    List<int> data = [0x02];
    List<int> command = getCommand(
      ckey,
      CommandType.scooterClose,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> getCRCShutDown(int cKey, int opt) {
    List<int> data = [0, opt];
    List<int> command = getCommand(
      cKey,
      CommandType.config,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> getCRCScooterIotInfo(int ckey) {
    List<int> data = [0x01];
    List<int> command = getCommand(
      ckey,
      CommandType.scooterIotInfo,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> getCRCScooterInfo(int ckey) {
    List<int> data = [0x01];
    List<int> command = getCommand(
      ckey,
      CommandType.scooterInfo,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> getCRCGetOldData(int cKey) {
    List<int> data = [0x01];
    List<int> command = getCommand(
      cKey,
      CommandType.oldData,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> getCRCClearOldData(int cKey) {
    List<int> data = [0x01];
    List<int> command = getCommand(
      cKey,
      CommandType.clearData,
      data,
    );
    return getXorCRCCommand(command);
  }

  @override
  List<int> addBytes(List<int> a, List<int> b) {
    return [...a, ...b];
  }

  @override
  List<int> intToBytes(int number) {
    return [
      (number >> 24) & 0xFF,
      (number >> 16) & 0xFF,
      (number >> 8) & 0xFF,
      number & 0xFF,
    ];
  }

  @override
  List<int> getXorCRCCommand(List<int> command) {
    List<int> xorCommand = encode(command);
    List<int> crcOrder = crcByte(xorCommand);
    return crcOrder;
  }

  @override
  List<int> encode(List<int> command) {
    List<int> xorComm = List<int>.filled(command.length, 0);

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
  List<int> crcByte(List<int> ori) {
    int crc8 = CRCUtil.calcCRC8(Uint8List.fromList(ori));
    List<int> ret = List<int>.from(ori)..add(crc8 & 0xFF);
    return ret;
  }

  // Add a dispose method if necessary
  void dispose() {
    _scooterCommandStreamController.close();
  }
}
