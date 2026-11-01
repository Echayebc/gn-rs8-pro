import 'dart:io';
import '../models/server_model.dart';
import 'gn_protocol.dart';

class ServerSender {
  Future<bool> sendToReceiver(ServerModel server, String receiverIp) async {
    try {
      Socket s = await Socket.connect(receiverIp, GnProtocol.port, timeout: Duration(seconds: 3));
      // نرسل أمر إضافة سيرفر بنفس بروتوكول G-MScreen
      String cmd = 'ADD_SERVER:${server.type}:${server.host}:${server.port}:${server.user}:${server.pass}\n';
      s.add(cmd.codeUnits);
      await s.flush();
      await Future.delayed(Duration(seconds: 1));
      s.destroy();
      return true;
    } catch(e){
      return false;
    }
  }
}
