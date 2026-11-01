class GnProtocol {
  static const String ip = '192.168.8.100';
  static const int port = 20000; // البورت لي درتو انت
  static const String bindCode = '210503352505';
  static const String serial = '210503352505*--1493';
  static List<int> authPacket() {
    return 'AUTH:$bindCode:$serial\n'.codeUnits;
  }
  static List<int> keyPacket(String key) {
    // G-MScreen الأصلي يبعث هكذا
    return 'KEY:$key\r\n'.codeUnits;
  }
}
