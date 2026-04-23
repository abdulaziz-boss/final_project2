import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});
  
  // Local state untuk kontrol UI
  final isObscure = true.obs;
  final isChecked = false.obs; // Checkbox untuk Syarat & Ketentuan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420), // membatasi lebar di tablet/web
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo/Header Title
                  Row(
                    children: [
                      const Icon(Icons.volunteer_activism, color: Color(0xFF006C49), size: 36),
                      const SizedBox(width: 8),
                      Text(
                        'zakkal.apl',
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontSize: 22,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Title Card Putih
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gabung Sebagai Relawan',
                          style: TextStyle(
                            color: Color(0xFF191C1D),
                            fontSize: 24,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Mulai perjalanan kontribusi sosial Anda hari ini.',
                          style: TextStyle(
                            color: Color(0xFF6C7A71),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // TextField Nama
                        _buildInputField(
                          label: 'Nama Lengkap',
                          controller: controller.nameC,
                          hintText: 'Nama Anda',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),

                        // TextField Email
                        _buildInputField(
                          label: 'Email',
                          controller: controller.emailC,
                          hintText: 'example@gmail.com',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // TextField Password
                        _buildPasswordField(),
                        const SizedBox(height: 24),

                        // Checkbox Syarat & Ketentuan
                        _buildTermsCheckbox(),
                        const SizedBox(height: 32),

                        // Tombol Register
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: (controller.isLoading.value || !isChecked.value)
                                ? null // Disable kalau belum centang atau sedang loading
                                : () {
                                    if (controller.nameC.text.isEmpty ||
                                        controller.emailC.text.isEmpty ||
                                        controller.passwordC.text.isEmpty) {
                                      Get.snackbar(
                                        'Validasi Gagal', 
                                        'Semua kolom wajib diisi ya!',
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        margin: const EdgeInsets.all(16)
                                      );
                                      return;
                                    }
                                    controller.register();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006C49),
                              disabledBackgroundColor: const Color(0xFF006C49).withOpacity(0.5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              elevation: 0,
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Daftar Sekarang',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                          ),
                        )),
                        const SizedBox(height: 28),

                        // Link pindah ke Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sudah punya akun? ',
                              style: TextStyle(
                                color: Color(0xFF3C4A42),
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Apabila user datang dari halaman login, kita back saja 
                                // agar tidak menumpuk stack (Atau navigasi .offNamed('/login'))
                                Get.offAllNamed('/login'); 
                              },
                              child: const Text(
                                'Masuk di sini',
                                style: TextStyle(
                                  color: Color(0xFF0051D5),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Footer Copyright
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      '© 2024 Digital Commons - zakkal.apl.\nMelayani dengan hati.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk membuat TextField yang rapi
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3C4A42),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF8C8D8E)),
            prefixIcon: Icon(icon, color: const Color(0xFF6C7A71), size: 22),
            filled: true,
            fillColor: const Color(0xFFF3F4F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF006C49), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  // Helper tersendiri untuk Password agar ada tombol show/hide
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kata Sandi',
          style: TextStyle(
            color: Color(0xFF3C4A42),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextField(
          controller: controller.passwordC,
          obscureText: isObscure.value,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Minimal 8 karakter',
            hintStyle: const TextStyle(color: Color(0xFF8C8D8E)),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6C7A71), size: 22),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF6C7A71),
                size: 22,
              ),
              onPressed: () => isObscure.value = !isObscure.value, // Toggle Password
            ),
            filled: true,
            fillColor: const Color(0xFFF3F4F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF006C49), width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        )),
      ],
    );
  }

  // Syarat dan Ketentuan Widget
  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => GestureDetector(
          onTap: () => isChecked.value = !isChecked.value,
          child: Container(
            margin: const EdgeInsets.only(top: 2, right: 12),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isChecked.value ? const Color(0xFF006C49) : Colors.white,
              border: Border.all(
                color: isChecked.value ? const Color(0xFF006C49) : const Color(0xFFBBCABF),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: isChecked.value 
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        )),
        Expanded(
          child: GestureDetector(
            onTap: () => isChecked.value = !isChecked.value, // Klik text juga mencentang
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Color(0xFF6C7A71),
                  fontSize: 13.5,
                  fontFamily: 'Inter',
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: 'Saya setuju dengan '),
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(color: Color(0xFF0051D5), fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' serta '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(color: Color(0xFF0051D5), fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' yang berlaku.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}