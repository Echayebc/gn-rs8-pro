import 'dart:io';

class MultiPortManager {
  static final MultiPortManager I = MultiPortManager._();
  MultiPortManager._();
  
  String ip = '192.168.8.100';
  Map<int, Socket> sockets = {};

  Future<void> connectAll() async {
    sockets.forEach((k,v){ try{v.destroy();}catch(_){} });
    sockets.clear();
    List<int> ports = [23,80,8001,8002,9000,20000];
    for (int p in ports) {
      try {
        var sock = await Socket.connect(ip, p, timeout: Duration(milliseconds: 800));
        if (p == 20000) {
          sock.write('KYN\x01210503352505\n');
          await sock.flush();
        }
        sockets[p] = sock;
      } catch (_) {}
    }
  }

  void sendKey(String key) {
    var s = sockets[20000];
    if (s != null) {
      s.write('KEY:$key\r\n');
      s.flush();
    }
  }

  void disconnect() {
    sockets.forEach((k,v)=>v.destroy());
    sockets.clear();
  }
}
