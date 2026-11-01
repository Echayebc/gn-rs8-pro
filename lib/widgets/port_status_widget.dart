import 'package:flutter/material.dart';
import '../services/port_scanner.dart';

class PortStatusWidget extends StatelessWidget {
  final List<PortInfo> ports;
  final String ip;
  const PortStatusWidget({super.key, required this.ports, required this.ip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('نتائج فحص $ip:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ports.map((p) => Chip(
              label: Text('${p.port}'),
              backgroundColor: p.isOpen ? Colors.green : Colors.red.shade900,
              labelStyle: TextStyle(color: Colors.white, fontSize: 12),
              avatar: Icon(p.isOpen ? Icons.check : Icons.close, color: Colors.white, size: 14),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
