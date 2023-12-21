abstract class IotScooterInterface {
  List<int> getCRCScooterClose({
    required int ckey,
  });
  List<int> getCRCScooterCloseResponse({required int ckey});
  List<int> getCRCShutDown({required int cKey, required int opt});
  List<int> getCRCScooterIotInfo({required int ckey});
  List<int> getCRCScooterInfo({required int ckey});
  List<int> getCRCGetOldData({required int cKey});
  List<int> getCRCClearOldData({required int cKey});
  List<int> addBytes(List<int> a, List<int> b);
  List<int> intToBytes(int number);
  List<int> getXorCRCCommand(List<int> command);
  List<int> encode(List<int> command);
  List<int> crcByte(List<int> ori);

  ///todo: typar todo y trailing comas
}
