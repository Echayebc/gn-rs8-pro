class GnProtocol {
  static const String ip = '192.168.8.100';
  static const int port = 20000;
  static const String bindCode = '210503352505';
  static const String serial = '210503352505*--1493';
  static List<int> authPacket() {
    String auth = 'AUTH:$bindCode:$serial\n';
    return auth.codeUnits;
  }
  static Map<String, String> keys = {
    'POWER': 'POWER', 'MUTE': 'MUTE', 'MENU': 'MENU', 'EXIT': 'EXIT', 'OK': 'OK',
    'UP': 'UP', 'DOWN': 'DOWN', 'LEFT': 'LEFT', 'RIGHT': 'RIGHT',
    'VOL+': 'VOLUP', 'VOL-': 'VOLDOWN', 'RED': 'RED', 'GREEN': 'GREEN', 
    'YELLOW': 'YELLOW', 'BLUE': 'BLUE',
    '1': '1', '2': '2', '3': '3', '4': '4', '5': '5', '6': '6', '7': '7', '8': '8', '9': '9', '0': '0', 'INFO': 'INFO'
  };
  static List<int> keyPacket(String key) {
    return 'KEY:${keys[key] ?? key}\n'.codeUnits;
  }
}
