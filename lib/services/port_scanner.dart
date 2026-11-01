import 'dart:io';

class PortInfo {
  final int port;
  final bool isOpen;
  final String banner;
  PortInfo({required this.port, required this.isOpen, this.banner = ''});
}

class PortScanner {
  static Future<List<PortInfo>> scanReceiver(String ip) async {
    List<int> toCheck = [20000, 23, 80, 8080, 9000, 1234];
    List<PortInfo> results = [];

    for (var port in toCheck) {
      try {
        final socket = await Socket.connect(ip, port, timeout: Duration(milliseconds: 800));
        socket.destroy();
        results.add(PortInfo(port: port, isOpen: true));
      } catch (_) {
        results.add(PortInfo(port: port, isOpen: false));
      }
    }
    return results;
  }
}
