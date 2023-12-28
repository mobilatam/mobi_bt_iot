import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:mobi_bt_iot/iot/constants/command_type.dart';
import 'package:mobi_bt_iot/iot/interfaces/iot_scooter_interface.dart';
import 'package:mobi_bt_iot/iot/utils/crc_util.dart';

class ScooterCommandHelper implements IotScooterInterface {
  static final ScooterCommandHelper _instance = ScooterCommandHelper._internal();

  factory ScooterCommandHelper() {
    return _instance;
  }

  ScooterCommandHelper._internal();

  final StreamController<List<int>> _scooterCommandStreamController = StreamController<List<int>>.broadcast();

  Stream<List<int>> get scooterCommandStream => _scooterCommandStreamController.stream;

  @override
  List<int> getCommand({
    required int ckey,
    required int commandType,
    required List<int> dataList,
  }) {
    List<int> head = [
      0xA3,
      0xA4,
    ]
        .map(
          (
            val,
          ) =>
              val.toSigned(8),
        )
        .toList();
    int len = dataList.length;
    int rand = Random().nextInt(256) - 127;
    List<int> command = addBytes(
      dataListA: head,
      dataListB: [
        len,
        rand,
        ckey,
        commandType,
      ],
    );
    return addBytes(
      dataListA: command,
      dataListB: dataList,
    );
  }

  @override
  List<int> getCRCCommunicationKey({
    required String deviceUniqueKey,
  }) {
    List<int> convertKeyToInt = List.filled(
      8,
      0,
    );
    for (int i = 0; i < deviceUniqueKey.length; i++) {
      convertKeyToInt[i] = deviceUniqueKey.codeUnitAt(i);
    }
    List<int> commandCommunication = getCommand(
      ckey: 0,
      commandType: CommandType.communicationKey,
      dataList: convertKeyToInt,
    );
    return getXorCRCCommand(
      dataCommand: commandCommunication,
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
      dataListA: data,
      dataListB: intToBytes(
        number: uid,
      ),
    );
    data = addBytes(
      dataListA: data,
      dataListB: intToBytes(
        number: timestamp,
      ),
    );
    data.add(
      0x0,
    );
    List<int> commandMessage = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterOpen,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> getCRCScooterOpenResponse({
    required int ckey,
  }) {
    List<int> data = [
      0x02,
    ];
    List<int> commandMessage = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterOpen,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> getCRCScooterClose({
    required String deviceUniqueKey,
    required int ckey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> commandMessage = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterClose,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> getCRCScooterCloseResponse({
    required int ckey,
  }) {
    List<int> data = [
      0x02,
    ];
    List<int> commandMessage = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterClose,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
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
    List<int> commandMessage = getCommand(
      ckey: cKey,
      commandType: CommandType.config,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> getCRCScooterIotInfo({
    required int ckey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> commandMessage = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterIotInfo,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> getCRCScooterInfo({
    required int ckey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> commandMessage = getCommand(
      ckey: ckey,
      commandType: CommandType.scooterInfo,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> getCRCGetOldData({
    required int cKey,
  }) {
    List<int> data = [
      0x01,
    ];
    List<int> commandMessage = getCommand(
      ckey: cKey,
      commandType: CommandType.oldData,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> getCRCClearOldData({
    required int cKey,
  }) {
    List<int> data = [0x01];
    List<int> commandMessage = getCommand(
      ckey: cKey,
      commandType: CommandType.clearData,
      dataList: data,
    );
    return getXorCRCCommand(
      dataCommand: commandMessage,
    );
  }

  @override
  List<int> addBytes({
    required List<int> dataListA,
    required List<int> dataListB,
  }) {
    return [
      ...dataListA,
      ...dataListB,
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
    required List<int> dataCommand,
  }) {
    List<int> xorCommand = encode(
      commandList: dataCommand,
    );
    List<int> crcOrder = crcByte(
      ori: xorCommand,
    );
    return crcOrder;
  }

  @override
  List<int> encode({
    required List<int> commandList,
  }) {
    List<int> xorComm = List<int>.filled(commandList.length, 0);

    xorComm[0] = commandList[0];
    xorComm[1] = commandList[1];
    xorComm[2] = commandList[2];
    xorComm[3] = (commandList[3] + 0x32);

    for (int i = 4; i < commandList.length; i++) {
      xorComm[i] = (commandList[i] ^ commandList[3]);
    }
    return xorComm;
  }

  @override
  List<int> crcByte({
    required List<int> ori,
  }) {
    int crc8 = CRCUtil.calcCRC8(
      dataList: Uint8List.fromList(ori),
    );
    List<int> ret = List<int>.from(
      ori,
    )..add(crc8 & 0xFF);
    return ret;
  }

  void dispose() {
    _scooterCommandStreamController.close();
  }
}
