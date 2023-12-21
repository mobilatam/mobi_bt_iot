abstract class BaseCommandInterface {
  List<int> addBytes({required List<int> a, required List<int> b});

  List<int> addSingleByte({required List<int> a, required int b});

  List<int> addInt({required List<int> a, required int b});

  List<int> addLong({required List<int> a, required int b});

  List<int> getCommand({required int ckey, required int commandType, required List<int> data});

  List<int> getXorCRCCommand({required List<int> command});

  List<int> encode({required List<int> command});

  List<int> crcByte({required List<int> ori});

  List<int> crcByte2({required List<int> ori});
}