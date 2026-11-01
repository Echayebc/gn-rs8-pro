import 'package:flutter/material.dart';
import 'services/multi_port_manager.dart';
import 'services/port_scanner.dart';

void main() {
  runApp(GnRs8ProApp());
}

class GnRs8ProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GN-RS8 PRO',
      theme: ThemeData.dark(),
      home: RemoteScreen(),
    );
  }
}

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
    setState(() => loading = true);
    MultiPortManager.I.ip = ip;
    ports = await PortScanner.scanAll(ip);
    await MultiPortManager.I.connectAll();
    setState(() => loading = false);
  }

  void _send(String key) {
    MultiPortManager.I.sendKey(key);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم الإرسال عبر بورت 20000: $key'), duration: Duration(milliseconds: 600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GN-RS8 PRO - $ip'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _start),
        ],
      ),
      body: loading
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('جاري فحص كل البورتات و الاتصال بـ $ip ...')
            ]))
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black26,
                  padding: EdgeInsets.all(8),
                  child: Wrap(
                    spacing: 6,
                    children: ports.map((p) {
                      bool connected = MultiPortManager.I.sockets.containsKey(p.port);
                      return Chip(
                        label: Text('${p.port} ${p.service}', style: TextStyle(fontSize: 11)),
                        backgroundColor: connected ? Colors.green : Colors.red.shade800,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),
                Text('جهاز التحكم - يعمل عبر بورت 20000 فقط', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.all(16),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _btn('POWER', Colors.red),
                      _btn('MUTE', null),
                      _btn('MENU', null),
                      _btn('CH+', null),
                      _btn('OK', Colors.blue),
                      _btn('CH-', null),
                      _btn('VOL-', null),
                      _btn('EXIT', null),
                      _btn('VOL+', null),
                      _btn('1', null),
                      _btn('2', null),
                      _btn('3', null),
                      _btn('4', null),
                      _btn('5', null),
                      _btn('6', null),
                      _btn('7', null),
                      _btn('8', null),
                      _btn('9', null),
                      _btn('INFO', null),
                      _btn('0', null),
                      _btn('RECALL', null),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: ElevatedButton.icon(
                    onPressed: _start,
                    icon: Icon(Icons.wifi),
                    label: Text('إعادة فحص و اتصال بكل البورتات'),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  ),
                )
              ],
            ),
    );
  }

  Widget _btn(String label, Color? color) {
    return ElevatedButton(
      onPressed: () => _send(label),
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
