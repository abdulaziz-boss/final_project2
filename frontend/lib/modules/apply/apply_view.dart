import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'apply_controller.dart';

class ApplyView extends GetView<ApplyController> {
  const ApplyView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet Warna Tema Hijau & Putih Bersih
    const Color primaryGreen = Color(0xFF047857); // Emerald Green
    const Color lightGreen = Color(0xFFE8F5E9);
    const Color textDark = Color(0xFF1E293B); // Slate 800
    const Color textGrey = Color(0xFF64748B); // Slate 500

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Background abu-abu ultra-light agar komponen putih menonjol
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        title: const Text(
          'Status Pendaftaran',
          style: TextStyle(
            color: textDark,
            fontSize: 18,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: textDark, size: 20),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Obx(() {
            // 🔄 1. LOADING STATE
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryGreen),
                ),
              );
            }

            final app = controller.application.value;

            // ❌ 2. BELUM APPLY (Tampilan Formulir Siap Daftar)
            if (app == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: lightGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.assignment_ind_outlined,
                        size: 80,
                        color: primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Siap Ambil Bagian?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "Daftarkan dirimu sekarang untuk bergabung sebagai volunteer dalam kegiatan hebat ini.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: textGrey, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.apply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                          shadowColor: primaryGreen.withOpacity(0.3),
                        ),
                        child: const Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // 🔥 3. STATUS VIEW (Sudah Apply: Pending / Accepted / Rejected)
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Besar Berdasarkan Status
                    _buildStatusIcon(app.status, primaryGreen),
                    
                    const SizedBox(height: 20),
                    
                    // Badge Status Kecil
                    _StatusBadge(status: app.status, primaryGreen: primaryGreen),

                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                    const SizedBox(height: 16),

                    // Detail Konten Dinamis Berdasarkan Status
                    if (app.status == 'pending') ...[
                      const Text(
                        "Pendaftaran Diproses",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textDark),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Mohon tunggu sebentar, penyelenggara sedang meninjau profil dan kelayakan berkas pendaftaranmu.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textGrey, height: 1.5, fontSize: 14),
                      ),
                    ],

                    if (app.status == 'accepted') ...[
                      const Text(
                        "Selamat, Kamu Diterima!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Persiapkan dirimu dengan baik dan silakan hadiri kegiatan sesuai dengan waktu serta lokasi yang telah ditentukan.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textGrey, height: 1.5, fontSize: 14),
                      ),
                    ],

                    if (app.status == 'rejected') ...[
                      const Text(
                        "Pendaftaran Belum Berhasil",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C)),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFEE2E2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Alasan Penolakan:",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF991B1B)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              app.alasan ?? 'Tidak ada alasan spesifik yang dicantumkan.',
                              style: const TextStyle(fontSize: 14, color: Color(0xFF7F1D1D), height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Helper untuk membuat Container Icon Besar di bagian atas status card
  Widget _buildStatusIcon(String status, Color primaryGreen) {
    IconData iconData;
    Color baseColor;

    switch (status) {
      case 'accepted':
        iconData = Icons.gpp_good_rounded;
        baseColor = const Color(0xFF10B981);
        break;
      case 'rejected':
        iconData = Icons.gpp_bad_rounded;
        baseColor = const Color(0xFFEF4444);
        break;
      default:
        iconData = Icons.hourglass_empty_rounded;
        baseColor = const Color(0xFFF59E0B);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 54, color: baseColor),
    );
  }
}

// ================= STATUS BADGE =================

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color primaryGreen;

  const _StatusBadge({required this.status, required this.primaryGreen});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case 'accepted':
        color = const Color(0xFF059669);
        icon = Icons.check_circle_rounded;
        text = "Diterima";
        break;
      case 'rejected':
        color = const Color(0xFFDC2626);
        icon = Icons.cancel_rounded;
        text = "Ditolak";
        break;
      default:
        color = const Color(0xFFD97706);
        icon = Icons.pending_actions_rounded;
        text = "Menunggu Persetujuan";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}