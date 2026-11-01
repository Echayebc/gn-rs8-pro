import 'package:flutter/material.dart';
import '../services/port_scanner.dart';

class PortStatusWidget extends StatelessWidget {
  final List<PortInfo> ports;
  final String ip;
  const PortStatusWidget({super.key, required this.ports, required this.ip});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Text('فحص: $ip',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
