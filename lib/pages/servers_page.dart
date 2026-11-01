import 'package:flutter/material.dart';
import '../models/server_model.dart';
import '../services/server_sender.dart';

class ServersPage extends StatefulWidget {
  @override State<ServersPage> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  final hostCtrl = TextEditingController();
  final portCtrl = TextEditingController(text: '12000');
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String type = 'CCCAM';
  String log = '';

  void addServer() async {
    ServerModel s = ServerModel(type: type, host: hostCtrl.text, port: portCtrl.text, user: userCtrl.text, pass: passCtrl.text);
    setState(()=> log = 'جاري الإرسال: ${s.toOscamLine()}');
    bool ok = await ServerSender().sendToReceiver(s, '192.168.8.100');
    setState(()=> log = ok ? '✅ تم الإرسال! اذهب للرسيفر Menu > Serveur' : '❌ فشل - سيتم حفظه محليا');
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('إضافة سيرفر - GN-RS8'), backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(value: type, isExpanded: true, items: [DropdownMenuItem(value: 'CCCAM', child: Text('CCcam')), DropdownMenuItem(value: 'IPTV', child: Text('IPTV Xtream'))], onChanged: (v)=> setState(()=> type=v!)),
            TextField(controller: hostCtrl, decoration: InputDecoration(labelText: 'Host / IP - مثلا: cccam.example.com')),
            TextField(controller: portCtrl, decoration: InputDecoration(labelText: 'Port - مثلا: 12000'), keyboardType: TextInputType.number),
            TextField(controller: userCtrl, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: passCtrl, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(icon: Icon(Icons.send), label: Text('إرسال للرسيفر 192.168.8.100'), onPressed: addServer)),
            SizedBox(height: 20),
            Text(log, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
