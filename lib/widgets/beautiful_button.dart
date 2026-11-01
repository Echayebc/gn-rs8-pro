import 'package:flutter/material.dart';

class BeautifulButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const BeautifulButton({super.key, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: onTap == null ? Colors.grey.shade300 : color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: onTap == null ? [] : [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color == Colors.white ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
      ),
    );
  }
}
