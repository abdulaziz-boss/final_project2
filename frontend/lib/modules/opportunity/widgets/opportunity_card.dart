import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../inbox/inbox_controller.dart';
import '../../../data/models/opportunity_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../shared/like/like_widget.dart';
import '../../shared/comment/comment_widget.dart';
import '../../shared/comment/comment_input.dart';
import '../../shared/comment/comment_count_widget.dart';
import '../controllers/opportunity_controller.dart';

// ─────────────────────────────────────────────
// Design Tokens
// ─────────────────────────────────────────────
class _T {
  // Primary green palette
  static const primary = Color(0xFF0A5C38);
  static const primaryDark = Color(0xFF083F27);
  static const primaryLight = Color(0xFFEAF4EE);
  static const primaryMid = Color(0xFF147A4A);
  static const primaryGlow = Color(0x1A0A5C38);

  // Neutrals
  static const ink = Color(0xFF111827);
  static const inkLight = Color(0xFF374151);
  static const muted = Color(0xFF6B7280);
  static const subtle = Color(0xFF9CA3AF);
  static const hairline = Color(0xFFE5E7EB);
  static const surface = Color(0xFFFAFAFA);

  // Accent
  static const blue = Color(0xFF2563EB);
  static const blueLight = Color(0xFFEFF6FF);
  static const amber = Color(0xFFD97706);
  static const amberLight = Color(0xFFFFFBEB);
  static const rose = Color(0xFFE11D48);
  static const roseLight = Color(0xFFFFF1F2);
  static const emerald = Color(0xFF059669);
  static const emeraldLight = Color(0xFFECFDF5);
}

// ─────────────────────────────────────────────
// OpportunityCard
// ─────────────────────────────────────────────
class OpportunityCard extends StatefulWidget {
  final OpportunityModel data;
  final String? applyStatus;

  const OpportunityCard({super.key, required this.data, this.applyStatus});

  @override
  State<OpportunityCard> createState() => _OpportunityCardState();
}

class _OpportunityCardState extends State<OpportunityCard> {
  bool _descExpanded = false;

  // ── Helpers ──────────────────────────────────
  Future<void> _openMap() async {
    final url = widget.data.mapsUrl ?? '';
    if (url.isEmpty) return;
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      Get.snackbar('Gagal', 'Tidak dapat membuka lokasi',
          backgroundColor: _T.rose, colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _openDetail() => Get.toNamed('/opportunityDetail', arguments: widget.data);

  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (_, sc) => _CommentSheet(
          scrollController: sc,
          opportunityId: widget.data.id,
          context: context,
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isOpen = d.status == 'open';
    final isOnline = d.tipe == 'online';
    final posterName = d.creator?.name ?? d.organization?.namaOrganisasi ?? 'Penyelenggara';
    final controller = Get.find<OpportunityController>();

    // Avatar
    String avatarUrl =
        'https://ui-avatars.com/api/?name=$posterName&background=0A5C38&color=fff&bold=true';
    if (d.creator?.fotoProfilUrl?.isNotEmpty == true) {
      avatarUrl = d.creator!.fotoProfilUrl!;
    } else if (d.organization?.logo != null) {
      final logo = d.organization!.logo!;
      avatarUrl = logo.startsWith('http') ? logo : '${ApiConstants.storageUrl}/$logo';
    }

    // Banner
    String? bannerUrl;
    if (d.foto != null) {
      bannerUrl = d.foto!.startsWith('http')
          ? d.foto
          : '${ApiConstants.storageUrl}/${d.foto}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 1. Header: Avatar + Info + Status ────
          _PostHeader(
            avatarUrl: avatarUrl,
            posterName: posterName,
            lokasi: d.lokasi,
            isMapActive: d.mapsUrl?.isNotEmpty == true,
            onMapTap: _openMap,
            isOpen: isOpen,
            isOnline: isOnline,
            applyStatus: widget.applyStatus,
          ),

          // ── 2. Banner / Gambar ────────────────────
          GestureDetector(
            onTap: _openDetail,
            child: _BannerImage(
              bannerUrl: bannerUrl,
              title: d.judul,
              isOpen: isOpen,
            ),
          ),

          // ── 3. Konten Teks ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Judul
                GestureDetector(
                  onTap: _openDetail,
                  child: Text(
                    d.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _T.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Meta row: tanggal + kuota
                _MetaRow(tanggal: d.tanggalMulai, kuota: d.kuota),
                const SizedBox(height: 10),

                // Deskripsi
                _DescBlock(
                  text: d.deskripsi,
                  expanded: _descExpanded,
                  onToggle: () => setState(() => _descExpanded = !_descExpanded),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),

          // ── 4. CTA Utama ──────────────────────────
          Obx(() {
            final isAdmin = controller.userRole.value == 'admin';
            return _PrimaryCtaBar(
              isOpen: isOpen,
              isAdmin: isAdmin,
              applyStatus: widget.applyStatus,
              onTap: isOpen
                  ? () {
                      if (isAdmin) {
                        Get.toNamed('/participants', arguments: d.id);
                      } else {
                        _openDetail();
                      }
                    }
                  : null,
            );
          }),

          // ── 5. Engagement Row ─────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                LikeWidget(opportunityId: d.id),
                _EngageBtn(
                  icon: Icons.chat_bubble_outline_rounded,
                  onTap: () => _showCommentSheet(context),
                  child: CommentCountWidget(
                    opportunityId: d.id,
                    initialCount: d.commentsCount,
                    isTextFormat: true,
                  ),
                ),
                _EngageBtn(
                  icon: Icons.share_outlined,
                  onTap: () => Get.find<InboxController>().showShareSheet(d),
                ),
                const Spacer(),
                // Bookmark-style sertifikat badge
                if (true) // ganti dengan d.hasSertifikat
                  _SertifikatBadge(),
              ],
            ),
          ),

          // Divider antar post (feed style)
          Container(height: 8, color: const Color(0xFFF3F4F6)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Post Header
// ─────────────────────────────────────────────
class _PostHeader extends StatelessWidget {
  final String avatarUrl;
  final String posterName;
  final String lokasi;
  final bool isMapActive;
  final VoidCallback onMapTap;
  final bool isOpen;
  final bool isOnline;
  final String? applyStatus;

  const _PostHeader({
    required this.avatarUrl,
    required this.posterName,
    required this.lokasi,
    required this.isMapActive,
    required this.onMapTap,
    required this.isOpen,
    required this.isOnline,
    this.applyStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: _T.primaryLight,
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          const SizedBox(width: 10),

          // Nama + Lokasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  posterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _T.ink,
                  ),
                ),
                if (lokasi.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: isMapActive ? onMapTap : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: isMapActive ? _T.rose : _T.subtle,
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            lokasi,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isMapActive ? _T.rose : _T.muted,
                              decoration: isMapActive ? TextDecoration.underline : null,
                              decorationColor: _T.rose,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Tipe + Status badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _TipeBadge(isOnline: isOnline),
              const SizedBox(height: 4),
              _StatusBadge(isOpen: isOpen, applyStatus: applyStatus),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipeBadge extends StatelessWidget {
  final bool isOnline;
  const _TipeBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOnline ? _T.blueLight : _T.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.language_rounded : Icons.place_rounded,
            size: 11,
            color: isOnline ? _T.blue : _T.primary,
          ),
          const SizedBox(width: 3),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isOnline ? _T.blue : _T.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOpen;
  final String? applyStatus;

  const _StatusBadge({required this.isOpen, this.applyStatus});

  @override
  Widget build(BuildContext context) {
    if (applyStatus != null) {
      final color = getStatusColor(applyStatus!);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 0.5),
        ),
        child: Text(
          getStatusText(applyStatus!),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOpen ? _T.emerald : _T.subtle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isOpen ? 'Dibuka' : 'Ditutup',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isOpen ? _T.emerald : _T.muted,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Banner Image
// ─────────────────────────────────────────────
class _BannerImage extends StatelessWidget {
  final String? bannerUrl;
  final String title;
  final bool isOpen;

  const _BannerImage({this.bannerUrl, required this.title, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (bannerUrl != null)
            CachedNetworkImage(
              imageUrl: bannerUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => _placeholder(),
              errorWidget: (_, __, ___) => _placeholder(),
            )
          else
            _placeholder(),

          // Subtle bottom vignette
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.25)],
                stops: const [0.55, 1.0],
              ),
            ),
          ),

          // Closed overlay
          if (!isOpen)
            Container(
              color: Colors.black.withOpacity(0.45),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded, color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Pendaftaran Ditutup',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Tap hint icon
          if (isOpen)
            Positioned(
              bottom: 10,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'Lihat detail',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: _T.primaryMid,
        child: Center(
          child: Icon(Icons.volunteer_activism_rounded, size: 52, color: Colors.white.withOpacity(0.2)),
        ),
      );
}

// ─────────────────────────────────────────────
// Meta Row (tanggal + kuota)
// ─────────────────────────────────────────────
class _MetaRow extends StatelessWidget {
  final String tanggal;
  final int kuota;

  const _MetaRow({required this.tanggal, required this.kuota});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaPill(
          icon: Icons.calendar_month_rounded,
          label: tanggal,
          bgColor: _T.primaryLight,
          iconColor: _T.primary,
        ),
        const SizedBox(width: 8),
        _MetaPill(
          icon: Icons.group_rounded,
          label: '$kuota peserta',
          bgColor: _T.blueLight,
          iconColor: _T.blue,
        ),
        const SizedBox(width: 8),
        _MetaPill(
          icon: Icons.workspace_premium_rounded,
          label: 'Sertifikat',
          bgColor: _T.amberLight,
          iconColor: _T.amber,
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;

  const _MetaPill({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Description Block
// ─────────────────────────────────────────────
class _DescBlock extends StatelessWidget {
  final String text;
  final bool expanded;
  final VoidCallback onToggle;

  const _DescBlock({
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          maxLines: expanded ? null : 2,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(
            color: _T.inkLight,
            fontSize: 13,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onToggle,
          child: Text(
            expanded ? 'Sembunyikan ↑' : 'Selengkapnya →',
            style: const TextStyle(
              color: _T.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Primary CTA Bar — titik fokus visual
// ─────────────────────────────────────────────
class _PrimaryCtaBar extends StatelessWidget {
  final bool isOpen;
  final bool isAdmin;
  final String? applyStatus;
  final VoidCallback? onTap;

  const _PrimaryCtaBar({
    required this.isOpen,
    required this.isAdmin,
    this.applyStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 15, color: _T.muted),
            SizedBox(width: 6),
            Text(
              'Pendaftaran Telah Ditutup',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _T.muted,
              ),
            ),
          ],
        ),
      );
    }

    // Sudah apply
    if (applyStatus != null) {
      final statusColor = getStatusColor(applyStatus!);
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: _T.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _T.primary.withOpacity(0.2)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility_outlined, size: 16, color: _T.primary),
                      SizedBox(width: 6),
                      Text(
                        'Lihat Detail',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _T.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withOpacity(0.25)),
              ),
              child: Text(
                getStatusText(applyStatus!),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Admin
    if (isAdmin) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: _T.primaryLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _T.primary.withOpacity(0.25)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_alt_rounded, size: 16, color: _T.primary),
                SizedBox(width: 8),
                Text(
                  'Lihat Partisipan',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: _T.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── CTA Utama: Daftar Sekarang ──
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_T.primaryMid, _T.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _T.primary.withOpacity(0.28),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.how_to_reg_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Daftar Sekarang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Engagement Button
// ─────────────────────────────────────────────
class _EngageBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Widget? child;

  const _EngageBtn({required this.icon, required this.onTap, this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: _T.muted),
            if (child != null) ...[const SizedBox(width: 4), child!],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sertifikat Badge (subtle)
// ─────────────────────────────────────────────
class _SertifikatBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: _T.amberLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspace_premium_rounded, size: 13, color: _T.amber),
          SizedBox(width: 4),
          Text(
            'Sertifikat',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _T.amber,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Comment Sheet
// ─────────────────────────────────────────────
class _CommentSheet extends StatelessWidget {
  final ScrollController scrollController;
  final int opportunityId;
  final BuildContext context;

  const _CommentSheet({
    required this.scrollController,
    required this.opportunityId,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // HANDLE
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const Divider(
              height: 1,
              color: _T.hairline,
            ),

            // LIST COMMENT
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CommentWidget(
                  opportunityId: opportunityId,
                ),
              ),
            ),

            // INPUT COMMENT
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFE5E7EB),
                    ),
                  ),
                ),
                child: CommentInput(
                  opportunityId: opportunityId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Status Helpers
// ─────────────────────────────────────────────
Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'accepted':
      return _T.emerald;
    case 'rejected':
      return _T.rose;
    default:
      return _T.amber;
  }
}

String getStatusText(String status) {
  switch (status.toLowerCase()) {
    case 'accepted':
      return 'Diterima ✓';
    case 'rejected':
      return 'Ditolak';
    default:
      return 'Menunggu';
  }
}