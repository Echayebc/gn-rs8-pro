import 'package:flutter/material.dart';
import 'dart:io';
import 'services/port_scanner.dart';
import 'widgets/port_status_widget.dart';

void main() => runApp(const GnRs8App());

class GnRs8App extends StatelessWidget {
  const GnRs8App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GN-RS8 Beautiful',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: const RemotePage(),
    );
  }
}

class RemotePage extends StatefulWidget {
  const RemotePage({super.key});
  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  late TextEditingController ipController;
  String ip = '192.168.1.15';
  List<PortInfo> ports = [];
  bool scanning = false;
  bool connected = false;
  Socket? socket;

  @override
  void initState() {
    super.initState();
    ipController = TextEditingController(text: ip);
  }

  @override
  void dispose() {
    ipController.dispose();
    socket?.destroy();
    super.dispose();
  }

  Future<void> doScan() async {
    ip = ipController.text.trim();
    setState(() { scanning = true; ports = []; });
    var result = await PortScanner.scanReceiver(ip);
    setState(() { ports = result; scanning = false; });
  }

  Future<void> doConnect() async {
    try {
      socket = await Socket.connect(ip, 20000, timeout: const Duration(seconds: 2));
      socket!.write('KYN\x01210503352505\n');
      await socket!.flush();
      setState(() => connected = true);
    } catch (e) {
      setState(() => connected = false);
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل: $e')));
    }
  }

  void sendKey(String k) async {
    socket?.write('KEY:$k\r\n');
    await socket?.flush();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GN-RS8 Pro - Beautiful', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Icon(Icons.circle, color: connected ? Colors.green : Colors.red, size: 14),
          SizedBox(width: 6),
          Text(connected ? 'متصل' : 'غير متصل', style: TextStyle(fontSize: 12)),
          SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: ipController, decoration: InputDecoration(labelText: 'IP الرسيفر', border: OutlineInputBorder(), prefixIcon: Icon(Icons.router)))),
                SizedBox(width: 8),
                ElevatedButton(onPressed: scanning ? null : doScan, child: Text(scanning ? '...' : 'فحص')),
              ],
            ),
            SizedBox(height: 10),
            if (ports.isNotEmpty) PortStatusWidget(ports: ports, ip: ip),
            if (ports.isEmpty && !scanning)
              Container(height: 80, width: double.infinity, decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12)), child: Center(child: Text('اضغط فحص البورتات لتعرف أن التطبيق يشتغل', style: TextStyle(color: Colors.white70)))),
            if (scanning) Padding(padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator()),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: doConnect,
              icon: Icon(Icons.wifi),
              label: Text(connected ? 'متصل $ip:20000' : 'اتصال 20000'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50), backgroundColor: connected ? Colors.green : Colors.blue, foregroundColor: Colors.white),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10,
                children: [
                  _btn('POWER', Colors.red),
                  _btn('MUTE', Colors.grey),
                  _btn('TV/RADIO', Colors.grey.shade600),
                  _btn('1', Colors.white), _btn('2', Colors.white), _btn('3', Colors.white),
                  _btn('VOL+', Colors.blue), _btn('OK', Colors.orange), _btn('CH+', Colors.blue),
                  _btn('VOL-', Colors.blue), _btn('MENU', Colors.grey), _btn('CH-', Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, Color color) {
    return ElevatedButton(
      onPressed: connected ? () => sendKey(label) : null,
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: color==Colors.white ? Colors.black : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 2),
      child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }
}
