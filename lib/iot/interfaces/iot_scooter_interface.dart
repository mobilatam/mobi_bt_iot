abstract class IotScooterInterface {
  List<int> getCommand({
    required int ckey,
    required int commandType,
    required List<int> stringToInt,
  });

  List<int> getCRCCommunicationKey({
    required String deviceKey,
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
    required List<int> a,
    required List<int> b,
  });

  List<int> intToBytes({
    required int number,
  });

  List<int> getXorCRCCommand({
    required List<int> command,
  });

  List<int> encode({
    required List<int> command,
  });

  List<int> crcByte({
    required List<int> ori,
  });

}
