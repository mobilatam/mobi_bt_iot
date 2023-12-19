

import 'constants/crc_lists.dart';

class CRCUtil {


  static int calcCRC8(List<int> data) {
    int crc8 = 0;
    for (int i = 0; i < data.length; i++) {
      int index = (crc8 ^ data[i]) & 0xFF;
      crc8 = crc8Table[index];
    }
    return crc8;
  }

  static int calcCRC16(List<int> data) {
    return _calcCRC16(data, 0, data.length);
  }

  static int _calcCRC16(
    List<int> data,
    int offset,
    int len, [
    int preval = 0xFFFF,
  ]) {
    int ucCRCHi = (preval & 0xFF00) >> 8;
    int ucCRCLo = preval & 0x00FF;
    int iIndex;
    for (int i = 0; i < len; i++) {
      iIndex = (ucCRCLo ^ data[offset + i]) & 0x00FF;
      ucCRCLo = ucCRCHi ^ tCrc16H[iIndex];
      ucCRCHi = tCrc16L[iIndex];
    }
    return ((ucCRCHi & 0x00FF) << 8) | (ucCRCLo & 0x00FF) & 0xFFFF;
  }
}
