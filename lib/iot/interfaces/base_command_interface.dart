abstract class BaseCommandInterface {
  List<int> addBytes({
    required List<int> dataListA,
    required List<int> dataListB,
  });

  List<int> addSingleByte({
    required List<int> dataListA,
    required int singleInteger,
  });

  List<int> addInt({
    required List<int> dataListA,
    required int singleInteger,
  });
  List<int> addLong({
    required List<int> dataListA,
    required int singleInteger,
  });

  List<int> crcByte({
    required List<int> ori,
  });

  List<int> crcByte2({
    required List<int> ori,
  });
}
