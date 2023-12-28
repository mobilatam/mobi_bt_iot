abstract class IotScooterInterface {
  List<int> getCommand({
    required int ckey,
    required int commandType,
    required List<int> dataList,
  });
  List<int> getCRCCommunicationKey({
    required String deviceUniqueKey,
  });

  List<int> getCRCScooterOpen({
    required int ckey,
    required int mode,
    required int uid,
    required int timestamp,
  });
  List<int> getCRCScooterOpenResponse({
    required int ckey,
  });

  List<int> getCRCScooterClose({
    required String deviceUniqueKey,
    required int ckey,
  });

  List<int> getCRCScooterCloseResponse({
    required int ckey,
  });

  List<int> getCRCShutDown({
    required int cKey,
    required int opt,
  });

  List<int> getCRCScooterIotInfo({
    required int ckey,
  });

  List<int> getCRCScooterInfo({
    required int ckey,
  });

  List<int> getCRCGetOldData({
    required int cKey,
  });

  List<int> getCRCClearOldData({
    required int cKey,
  });

  List<int> addBytes({
    required List<int> dataListA,
    required List<int> dataListB,
  });

  List<int> intToBytes({
    required int number,
  });

  List<int> getXorCRCCommand({
    required List<int> dataCommand,
  });
  List<int> encode({
    required List<int> commandList,
  });

  List<int> crcByte({
    required List<int> ori,
  });
}
