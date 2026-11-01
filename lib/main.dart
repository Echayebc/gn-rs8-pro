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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
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
  String ip = '192.168.1.15';
  List<PortInfo> ports = [];
  bool scanning = false;
  bool connected = false;
  Socket? socket;

  Future<void> doScan() async {
    setState(() { scanning = true; ports = []; });
    var result = await PortScanner.scanReceiver(ip);
    setState(() { ports = result; scanning = false; });
  }

  Future<void> doConnect() async {
    try {
      socket = await Socket.connect(ip, 20000, timeout: const Duration(seconds: 2));
      socket!.write('KYN\x01210503352505\n');
      await socket!.flush();
      setState(() { connected = true; });
    } catch (e) {
      setState(() { connected = false; });
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل: $e')));
      }
    }
  }

  void sendKey(String k){
    socket?.write('KEY:$k\r\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('GN-RS8 Pro - Beautiful'),
        backgroundColor: Colors.white,
        actions: [
          Icon(Icons.circle, color: connected ? Colors.green : Colors.red, size: 14),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // خانة الـ IP
            Row(
              children: [
                Expanded(child: TextField(
                  decoration: const InputDecoration(labelText: 'IP الرسيفر', border: OutlineInputBorder()),
                  controller: TextEditingController(text: ip),
                  onChanged: (v)=> ip=v,
                )),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: doScan, child: Text(scanning ? '...' : 'فحص البورتات')),
              ],
            ),
            const SizedBox(height: 10),
            // الشاشة الصغيرة لي طلبتها
            if (ports.isNotEmpty) PortStatusWidget(ports: ports, ip: ip),
            if (ports.isEmpty && !scanning)
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('اضغط فحص البورتات لتعرف أن التطبيق يشتغل', style: TextStyle(color: Colors.white70))),
              ),
            if (scanning) const LinearProgressIndicator(),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: doConnect,
              icon: const Icon(Icons.wifi),
              label: Text(connected ? 'متصل $ip:20000' : 'اتصال'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: connected ? Colors.green : Colors.blue, foregroundColor: Colors.white),
            ),
            const SizedBox(height: 16),
            // الريموت الأبيض الجميل
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _btn('POWER', Colors.red),
                  _btn('MUTE', Colors.grey),
                  _btn('TV/RADIO', Colors.grey),
                  _btn('1', Colors.white),
                  _btn('2', Colors.white),
                  _btn('3', Colors.white),
                  _btn('VOL+', Colors.blue),
                  _btn('OK', Colors.orange),
                  _btn('CH+', Colors.blue),
                  _btn('VOL-', Colors.blue),
                  _btn('MENU', Colors.grey),
                  _btn('CH-', Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, Color color){
    return ElevatedButton(
      onPressed: connected ? () => sendKey(label) : null,
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: color==Colors.white ? Colors.black : Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
    );
  }
}
