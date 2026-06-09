import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MobileFrame extends StatelessWidget {
  final Widget child;

  const MobileFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Aktifkan bingkai HP HANYA jika jalan di Web/Laptop dan layar lebar (> 600px)
    if (kIsWeb && MediaQuery.of(context).size.width > 600) {
      return Scaffold(
        backgroundColor: const Color(0xFF121214), // Background gelap luar HP (Modern Tech Tech Aesthetic)
        body: Center(
          child: Container(
            width: 412, // Lebar standar HP modern
            height: 860, // Tinggi standar HP modern
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40), // Sudut melengkung layar HP
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
              border: Border.all(
                color: const Color(0xFF202024), // Warna bezel fisik HP fisik
                width: 12,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: child,
            ),
          ),
        ),
      );
    }

    // Jika dibuka di HP asli, langsung tampil full screen tanpa frame
    return child;
  }
}