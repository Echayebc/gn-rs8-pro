import 'dart:io';

class PortInfo {
  final int port;
  final bool isOpen;
  final String name;
  PortInfo(this.port, this.isOpen, this.name);
}

class PortScanner {
  // البورتات المهمة تاع GN-RS8
  static final Map<int, String> gnPorts = {
    21: 'FTP',
    23: 'Telnet',
    80: 'Web',
    8001: 'Web Alt',
    20000: 'Remote Control',
    50000: 'Discovery',
    9000: 'Streaming',
  };

  static Future<List<PortInfo>> scanReceiver(String ip) async {
    List<PortInfo> results = [];
    for (var entry in gnPorts.entries) {
      bool open = await _isPortOpen(ip, entry.key);
      results.add(PortInfo(entry.key, open, entry.value));
    }
    return results;
  }

  static Future<bool> _isPortOpen(String ip, int port) async {
    try {
      var socket = await Socket.connect(ip, port,
          timeout: const Duration(milliseconds: 500));
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }
}
