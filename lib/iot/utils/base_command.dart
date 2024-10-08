import 'package:mobi_bt_iot/iot/utils/crc_util.dart';

class BaseCommand {
  static List<int> addBytes({
    required List<int> dataListA,
    required List<int> dataListB,
  }) {
    return [
      ...dataListA,
      ...dataListB,
    ];
  }

  static List<int> addSingleByte({
    required List<int> dataListA,
    required int singleInteger,
  }) {
    return [
      ...dataListA,
      singleInteger,
    ];
  }

  static List<int> addInt({
    required List<int> dataListA,
    required int singleInteger,
  }) {
    List<int> bBytes = [
      (singleInteger >> 24) & 0xFF,
      (singleInteger >> 16) & 0xFF,
      (singleInteger >> 8) & 0xFF,
      singleInteger & 0xFF,
    ];
    return addBytes(
      dataListA: dataListA,
      dataListB: bBytes,
    );
  }

  static List<int> addLong({
    required List<int> dataListA,
    required int singleInteger,
  }) {
    return addInt(
      dataListA: dataListA,
      singleInteger: singleInteger,
    );
  }

  static List<int> crcByte({
    required List<int> ori,
  }) {
    List<int> ret = List.from(ori)
      ..add(
        CRCUtil.calcCRC8(
          dataList: ori,
        ),
      );
    return ret;
  }

  static List<int> crcByte2({
    required List<int> ori,
  }) {
    List<int> ret = [
      CRCUtil.calcCRC8(
        dataList: ori,
      ),
      ...ori,
    ];
    return ret;
  }
}
