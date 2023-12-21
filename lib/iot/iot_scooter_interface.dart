abstract class IotScooterInterface {
  List<int> getCRCScooterClose(int ckey);
  List<int> getCRCScooterCloseResponse(int ckey);
  List<int> getCRCShutDown(int cKey, int opt);
  List<int> getCRCScooterIotInfo(int ckey);
  List<int> getCRCScooterInfo(int ckey);
  List<int> getCRCGetOldData(int cKey);
  List<int> getCRCClearOldData(int cKey);
  List<int> addBytes(List<int> a, List<int> b);
  List<int> intToBytes(int number);
  List<int> getXorCRCCommand(List<int> command);
  List<int> encode(List<int> command);
  List<int> crcByte(List<int> ori);
}
