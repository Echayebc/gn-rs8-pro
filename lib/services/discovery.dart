import 'dart:io';

class DiscoveryService {
  // يقلب على الرسيفر وحدو في الشبكة
  static Future<String?> findGnRs8() async {
    List<String> subnets = ['192.168.1', '192.168.0', '192.168.8', '192.168.43'];
    
    for (var subnet in subnets) {
      for (int i = 1; i < 50; i++) {
        String ip = '$subnet.$i';
        try {
          var sock = await Socket.connect(ip, 20000,
              timeout: const Duration(milliseconds: 150));
          sock.destroy();
          return ip; // لقيناه!
        } catch (_) {}
      }
    }
    return null;
  }
}
