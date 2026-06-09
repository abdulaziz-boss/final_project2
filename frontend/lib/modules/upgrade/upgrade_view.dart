import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'upgrade_controller.dart'; // Diubah ke UpgradeController

class UpgradePremiumView extends GetView<UpgradeController> { // Menggunakan UpgradeController
  const UpgradePremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF191C1D)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Daftar Organisasi',
          style: TextStyle(
            color: Color(0xFF191C1D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        final isLoading = controller.isLoading.value;

        return Stack(
          children: [
            Form(
              key: controller.formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                children: [
                  // Premium Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF006C49), Color(0xFF028A5D)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF006C49).withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.stars, color: Colors.amber, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'Fitur Premium Admin',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Dengan upgrade ke akun organisasi/premium, Anda dapat mulai membuat program relawan sendiri dan merekrut partisipan.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  Center(
                    child: GestureDetector(
                      onTap: controller.pickLogo,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(() {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                                border: Border.all(color: const Color(0xFF006C49), width: 2),
                                image: controller.selectedLogo.value != null
                                    ? DecorationImage(
                                        image: FileImage(controller.selectedLogo.value!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: controller.selectedLogo.value == null
                                  ? const Icon(Icons.business, size: 50, color: Colors.grey)
                                  : null,
                            );
                          }),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF006C49),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  
                  const Text(
                    'Informasi Organisasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C4A42),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: controller.namaController,
                    label: 'Nama Organisasi',
                    icon: Icons.business,
                    hint: 'Masukkan nama resmi organisasi',
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nama organisasi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: controller.deskripsiController,
                    label: 'Deskripsi Singkat',
                    icon: Icons.description,
                    hint: 'Jelaskan tujuan dan bidang organisasi',
                    maxLines: 4,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Deskripsi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: controller.alamatController,
                    label: 'Alamat',
                    icon: Icons.location_on,
                    hint: 'Lokasi kantor atau sekretariat (opsional)',
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: controller.websiteController,
                    label: 'Website',
                    icon: Icons.language,
                    hint: 'Contoh: https://organisasi.org (opsional)',
                    keyboardType: TextInputType.url,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final text = v.trim();
                      String checkVal = text;
                      if (!text.startsWith('http://') && !text.startsWith('https://')) {
                        checkVal = 'https://$text';
                      }
                      final uri = Uri.tryParse(checkVal);
                      if (uri == null || !uri.hasScheme || !uri.hasAuthority || !uri.authority.contains('.')) {
                        return 'Website harus berupa URL valid dengan format http/https';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006C49),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (controller.formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              await controller.requestUpgrade();
                            }
                          },
                    child: const Text(
                      'Kirim Permintaan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF006C49),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF747975)),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFA1A5A2), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF006C49)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF006C49), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}