import 'package:flutter/material.dart';
import 'services/connection_service.dart';
import 'pages/servers_page.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: RemotePage()));

class RemotePage extends StatefulWidget {
  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  final conn = ConnectionService();
  String status = 'غير متصل - فعل G-MScreen في الرسيفر Menu > Réseau';
  bool loading = false;

  Future<void> doConnect() async {
    setState(() => loading = true);
    bool ok = await conn.connect();
    setState(() {
      loading = false;
      status = ok ? '✅ متصل ${conn.connectedIp}:${conn.connectedPort}' : '❌ فشل - تأكد نفس WiFi (192.168.8.x)';
    });
  }

  Widget btn(String label, {Color? c}) => Expanded(
    child: Container(
      height: 62,
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: c ?? Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        onPressed: () async {
          try {
            await conn.sendKey(label);
          } catch(e){
            setState(()=> status = 'غير متصل - اضغط اتصال');
          }
        },
        child: FittedBox(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('GN-RS8 Plus'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(Icons.dns, color: Colors.blue),
            onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ServersPage())),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            color: conn.isConnected ? Colors.green[100] : Colors.red[100],
            child: Text(status, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.wifi),
                      label: Text(loading ? 'نبحث...' : 'إتصال'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                      onPressed: doConnect,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.dns),
                    label: Text('سيرفرات'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                    onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> ServersPage())),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(6),
              children: [
                Row(children: [btn('POWER', c: Colors.red[200]), btn('MUTE'), btn('1'), btn('2')]),
                Row(children: [btn('3'), btn('4'), btn('5'), btn('6')]),
                Row(children: [btn('7'), btn('8'), btn('9'), btn('0')]),
                Row(children: [btn('MENU'), btn('EXIT'), btn('OK', c: Colors.blue[100]), btn('INFO')]),
                Row(children: [btn('UP'), btn('DOWN'), btn('LEFT'), btn('RIGHT')]),
                Row(children: [btn('VOL+'), btn('VOL-'), btn('RED', c: Colors.red[100]), btn('GREEN', c: Colors.green[100])]),
                Row(children: [btn('YELLOW', c: Colors.yellow[100]), btn('BLUE', c: Colors.blue[100]), Expanded(child: SizedBox()), Expanded(child: SizedBox())]),
                SizedBox(height: 20),
                Center(child: Text('G-MScreen Pro - Bind: 210503352505', style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
