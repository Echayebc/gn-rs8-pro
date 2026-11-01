import 'dart:io';

class PortInfo {
  final int port;
  final bool isOpen;
  final String service;
  PortInfo({required this.port, required this.isOpen, required this.service});
}

class PortScanner {
  static Map<int, String> gnPorts = {
    23: 'Telnet',
    80: 'Web',
    8001: 'Stream1',
    8002: 'Stream2',
    9000: 'Stream3',
    20000: 'Remote',
  };

  static Future<List<PortInfo>> scanAll(String ip) async {
    List<Future<PortInfo>> tasks = [];
    for (var e in gnPorts.entries) {
      tasks.add(_check(ip, e.key, e.value));
    }
    return await Future.wait(tasks);
  }

  static Future<PortInfo> _check(String ip, int port, String name) async {
    try {
      var s = await Socket.connect(ip, port, timeout: Duration(milliseconds: 700));
      s.destroy();
      return PortInfo(port: port, isOpen: true, service: name);
    } catch (_) {
      return PortInfo(port: port, isOpen: false, service: name);
    }
  }
}
