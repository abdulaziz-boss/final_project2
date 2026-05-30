import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_view.dart';
import '../bindings/edit_profile_binding.dart';
import '../../post/create_post_view.dart';
import '../../post/create_post_binding.dart';
import '../../../core/constants/api_constants.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
            Icon(Icons.volunteer_activism, color: Color(0xFF047857), size: 28),
            SizedBox(width: 8),
            Text(
              'GoVolunter',
              style: TextStyle(
                color: Color(0xFF047857),
                fontSize: 20,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Obx(() {
            if (controller.isCurrentUser.value) {
              return IconButton(
                icon: const Icon(Icons.logout, color: Color(0xFF475569)),
                onPressed: controller.logout,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        // loading awal
        if (controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value!;

        final isAdmin = user.role == 'admin' || user.role == 'super_admin';

        return RefreshIndicator(
          onRefresh: controller.getProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Profil (Foto, Nama, Verified)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            color: const Color(0xFFE7E8E9),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                user.fotoProfilUrl ??
                                    'https://ui-avatars.com/api/?name=${user.name}',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (controller.isCurrentUser.value)
                          GestureDetector(
                            onTap: () async {
                              // Navigasi ke EditProfileView dengan data user
                              final result = await Get.to(
                                () => const EditProfileView(),
                                arguments: user,
                                binding: EditProfileBinding(),
                              );
                              // Jika berhasil update, refresh profile
                              if (result == true) {
                                controller.getProfile();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF006C49),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          )
                        else if (user.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF316BF3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'VERIFIED',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF191C1D),
                            ),
                          ),
                          Text(
                            '@${user.username}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0051D5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Stats row (IG Style)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStatItem(
                                isAdmin
                                    ? controller.opportunities.length.toString()
                                    : '0',
                                isAdmin ? 'Postingan' : 'Aktivitas',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Action Buttons (Chat / Upgrade)
                          Row(
                            children: [
                              if (!controller.isCurrentUser.value) ...[
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE1E3E4),
                                      foregroundColor: const Color(0xFF191C1D),
                                      elevation: 0,
                                    ),
                                    onPressed: controller.startChat,
                                    child: const Text('Pesan'),
                                  ),
                                ),
                              ] else if (user.role == 'user') ...[
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF006C49),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                    ),
                                    onPressed: controller.showUpgradeForm,
                                    child: const Text('Upgrade Premium'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Bio / Deskripsi
                if (user.bio != null && user.bio!.isNotEmpty)
                  Text(
                    user.bio!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C4A42),
                    ),
                  ),

                const SizedBox(height: 16),

                // Konten Bawah (Postingan atau Placeholder)
                if (isAdmin) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Postingan Kegiatan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191C1D),
                        ),
                      ),
                      if (controller.isCurrentUser.value)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF006C49).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFF006C49),
                            ),
                            onPressed: () async {
                              final result = await Get.to(
                                () => const CreatePostView(),
                                binding: CreatePostBinding(),
                              );
                              if (result == true) {
                                controller.getProfile();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (controller.opportunities.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          "Belum ada postingan.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: controller.opportunities.length,
                      itemBuilder: (context, index) {
                        final opp = controller.opportunities[index];
                        String? bannerUrl;
                        if (opp.foto != null) {
                          bannerUrl = opp.foto!.startsWith('http')
                              ? opp.foto
                              : '${ApiConstants.storageUrl}/${opp.foto}';
                        }

                        return GestureDetector(
                          onTap: () =>
                              Get.toNamed('/opportunityDetail', arguments: opp),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: bannerUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: bannerUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.broken_image),
                                    )
                                  : Container(
                                      color: const Color(
                                        0xFF006C49,
                                      ).withOpacity(0.08),
                                      child: const Center(
                                        child: Icon(
                                          Icons.volunteer_activism_outlined,
                                          color: Color(0xFF006C49),
                                          size: 28,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.volunteer_activism_outlined,
                          size: 64,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Mari Berkontribusi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Anda belum memiliki akses untuk membuat kegiatan. Daftarkan diri Anda atau organisasi Anda untuk mulai membagikan kegiatan relawan.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 16),
                        if (controller.isCurrentUser.value)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006C49),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: controller.showUpgradeForm,
                            child: const Text('Upgrade ke Premium'),
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
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Color(0xFF006C49),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF475569),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
