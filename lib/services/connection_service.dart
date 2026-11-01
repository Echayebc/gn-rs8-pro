import 'dart:io';
import 'dart:async';
import 'gn_protocol.dart';

class ConnectionService {
  Socket? _socket;
  String connectedIp='';
  int connectedPort=0;
  Socket? get socket => _socket;
  bool get isConnected => _socket != null;
  
  Future<bool> connect({String? ip}) async {
    String targetIp = ip ?? GnProtocol.ip;
    try {
      _socket = await Socket.connect(targetIp, GnProtocol.port, timeout: Duration(seconds:3));
      connectedIp = targetIp;
      connectedPort = GnProtocol.port;
      _socket!.add(GnProtocol.authPacket());
      await _socket!.flush();
      await Future.delayed(Duration(seconds:1));
      return true;
    } catch(e) {
      _socket = null;
      for(int p in [2000, 8001, 8080, 23]) {
        try {
          _socket = await Socket.connect(targetIp, p, timeout: Duration(seconds:1));
          connectedIp = targetIp;
          connectedPort = p;
          _socket!.add(GnProtocol.authPacket());
          await _socket!.flush();
          return true;
        } catch(_){}
      }
      return false;
    }
  }
  
  Future<void> sendKey(String key) async {
    if(_socket==null) throw Exception('غير متصل');
    _socket!.add(GnProtocol.keyPacket(key));
    await _socket!.flush();
  }
  
  void disconnect(){
    _socket?.destroy();
    _socket=null;
  }
}
