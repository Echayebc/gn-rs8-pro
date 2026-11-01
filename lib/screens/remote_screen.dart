import 'package:flutter/material.dart';
import '../services/multi_port_manager.dart';
import '../services/port_scanner.dart';

class RemoteScreen extends StatefulWidget {
  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  List<PortInfo> ports = [];
  bool loading = true;
  String ip = '192.168.8.100';

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    setState(()=> loading = true);
    // 1- فحص كل البورتات
    ports = await PortScanner.scanAll(ip);
    // 2- اتصال بكل البورتات المفتوحة
    await MultiPortManager.I.connectAll();
    setState(()=> loading = false);
  }

  void _send(String key){
    // يبعت غير عبر بورت 20000
    MultiPortManager.I.sendKey(key);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('أرسلت: $key عبر 20000')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GN-RS8 PRO - $ip')),
      body: loading ? Center(child: CircularProgressIndicator()) :
      Column(children: [
        // حالة البورتات
        Wrap(children: ports.map((p)=> Chip(
          label: Text('${p.port} ${p.service}'),
          backgroundColor: MultiPortManager.I.sockets.containsKey(p.port) ? Colors.green : Colors.red,
        )).toList()),
        Divider(),
        // أزرار الريموت - تخدم غير ب 20000
        Expanded(child: GridView.count(crossAxisCount: 3, children: [
          ElevatedButton(onPressed: ()=> _send('POWER'), child: Text('POWER')),
          ElevatedButton(onPressed: ()=> _send('MUTE'), child: Text('MUTE')),
          ElevatedButton(onPressed: ()=> _send('MENU'), child: Text('MENU')),
          ElevatedButton(onPressed: ()=> _send('CH+'), child: Text('CH+')),
          ElevatedButton(onPressed: ()=> _send('OK'), child: Text('OK')),
          ElevatedButton(onPressed: ()=> _send('CH-'), child: Text('CH-')),
          ElevatedButton(onPressed: ()=> _send('VOL-'), child: Text('VOL-')),
          ElevatedButton(onPressed: ()=> _send('EXIT'), child: Text('EXIT')),
          ElevatedButton(onPressed: ()=> _send('VOL+'), child: Text('VOL+')),
        ])),
        ElevatedButton(onPressed: _start, child: Text('إعادة فحص واتصال كل البورتات'))
      ]),
    );
  }
}
