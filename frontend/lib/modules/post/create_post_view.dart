import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'create_post_controller.dart';

class CreatePostView extends GetView<CreatePostController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFC),
        elevation: 0,
        scrolledUnderElevation: 1,
        title: const Row(
          children: [
            Icon(Icons.volunteer_activism, color: Color(0xFF006C49), size: 28),
            SizedBox(width: 8),
            Text(
              'Tambah Lowongan',
              style: TextStyle(
                color: Color(0xFF006C49),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Color(0xFF006C49)),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // IMAGE UPLOAD THUMBNAIL
            Obx(() {
              return GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: controller.selectedImage.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            controller.selectedImage.value!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 48, color: Color(0xFF006C49)),
                              SizedBox(height: 10),
                              Text(
                                'Upload Foto Thumbnail',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF006C49),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Format JPG/PNG maks. 5MB',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // SECTION 1: DETAILS
            _buildSectionHeader('Detail Kegiatan', Icons.description_outlined),
            const SizedBox(height: 12),

            // TITLE
            _buildTextField(
              controller: controller.titleController,
              label: 'Judul Lowongan',
              hint: 'Contoh: Relawan Bersih Pantai Kuta',
              validator: (v) => v!.isEmpty ? 'Judul tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),

            // DESCRIPTION
            _buildTextField(
              controller: controller.descriptionController,
              label: 'Deskripsi Lengkap',
              hint: 'Deskripsikan tugas relawan, syarat, dan manfaat...',
              maxLines: 5,
              validator: (v) => v!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),

            // CATEGORY
            Obx(() {
              return DropdownButtonFormField<int>(
                value: controller.selectedCategoryId.value,
                items: controller.categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat['id'] as int,
                    child: Text(cat['name'] ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedCategoryId.value = value;
                },
                decoration: _buildInputDecoration(
                  label: 'Kategori Kegiatan',
                  prefixIcon: const Icon(Icons.category_outlined, color: Color(0xFF006C49)),
                ),
                validator: (v) => v == null ? 'Pilih kategori terlebih dahulu' : null,
              );
            }),

            const SizedBox(height: 24),

            // SECTION 2: LOGISTICS
            _buildSectionHeader('Logistik & Waktu', Icons.calendar_month_outlined),
            const SizedBox(height: 12),

            // TIPE (Online / Offline)
            Obx(() {
              return DropdownButtonFormField<String>(
                value: controller.selectedType.value,
                items: const [
                  DropdownMenuItem(value: 'offline', child: Text('Offline (Tatap Muka)')),
                  DropdownMenuItem(value: 'online', child: Text('Online (Daring)')),
                ],
                onChanged: (value) {
                  controller.selectedType.value = value!;
                },
                decoration: _buildInputDecoration(
                  label: 'Tipe Kegiatan',
                  prefixIcon: const Icon(Icons.language_outlined, color: Color(0xFF006C49)),
                ),
              );
            }),
            const SizedBox(height: 16),

            // LOKASI
            _buildTextField(
              controller: controller.locationController,
              label: 'Lokasi / Alamat',
              hint: 'Contoh: Pantai Kuta, Bali atau Zoom Meeting',
              prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFF006C49)),
              validator: (v) => v!.isEmpty ? 'Lokasi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),

            // GOOGLE MAPS URL
            _buildTextField(
              controller: controller.mapsUrlController,
              label: 'Link Google Maps',
              hint: 'https://maps.google.com/....',
              prefixIcon: const Icon(Icons.map_outlined, color: Color(0xFF006C49)),
              keyboardType: TextInputType.url,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Link Maps tidak boleh kosong';
                if (!Uri.parse(v).isAbsolute) return 'Format url tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // KUOTA
            _buildTextField(
              controller: controller.kuotaController,
              label: 'Kuota Relawan (Orang)',
              hint: 'Contoh: 50',
              prefixIcon: const Icon(Icons.people_alt_outlined, color: Color(0xFF006C49)),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Kuota tidak boleh kosong';
                if (int.tryParse(v) == null) return 'Kuota harus berupa angka';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // DATES SELECTOR
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final date = controller.tanggalMulai.value;
                    return _buildDatePickerButton(
                      context,
                      label: 'Mulai',
                      dateStr: date == null ? 'Pilih Tanggal' : '${date.day}/${date.month}/${date.year}',
                      isStart: true,
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final date = controller.tanggalSelesai.value;
                    return _buildDatePickerButton(
                      context,
                      label: 'Selesai',
                      dateStr: date == null ? 'Pilih Tanggal' : '${date.day}/${date.month}/${date.year}',
                      isStart: false,
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 36),

            // SUBMIT BUTTON
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006C49),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.createPost,
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Publish Kegiatan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF006C49), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerButton(BuildContext context, {required String label, required String dateStr, required bool isStart}) {
    return GestureDetector(
      onTap: () => controller.selectDate(context, isStart),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.date_range, size: 16, color: Color(0xFF006C49)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    Widget? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _buildInputDecoration(label: label, hint: hint, prefixIcon: prefixIcon),
      validator: validator,
    );
  }

  InputDecoration _buildInputDecoration({required String label, String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      labelStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
      floatingLabelStyle: const TextStyle(color: Color(0xFF006C49), fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF006C49), width: 2),
      ),
    );
  }
}