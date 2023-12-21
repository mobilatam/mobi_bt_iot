abstract class BaseCommandInterface {
  List<int> addBytes(List<int> a, List<int> b);
  List<int> addSingleByte(List<int> a, int b);
  List<int> addInt(List<int> a, int b);
  List<int> addLong(List<int> a, int b);
  List<int> getCommand(int ckey, int commandType, List<int> data);
  List<int> getXorCRCCommand(List<int> command);
  List<int> encode(List<int> command);
  List<int> crcByte(List<int> ori);
  List<int> crcByte2(List<int> ori);
}