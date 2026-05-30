import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Deep Gradient Background ──────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF011F12),
                  Color(0xFF013D22),
                  Color(0xFF005C34),
                  Color(0xFF006C49),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Decorative radial glow – top-left ────────────────────────
          Positioned(
            top: -80,
            left: -80,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF34D399).withValues(alpha: 0.18),
                ),
              ),
            ),
          ),

          // ── Decorative radial glow – bottom-right ────────────────────
          Positioned(
            bottom: -60,
            right: -60,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 110, sigmaY: 110),
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6EE7B7).withValues(alpha: 0.12),
                ),
              ),
            ),
          ),

          // ── Decorative glow – centre right ────────────────────────────
          Positioned(
            top: size.height * 0.3,
            right: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.07),
                ),
              ),
            ),
          ),

          // ── Scattered dot particles ────────────────────────────────────
          ..._buildParticles(size),

          // ── Fine grid mesh overlay ────────────────────────────────────
          Opacity(
            opacity: 0.04,
            child: CustomPaint(
              size: size,
              painter: _GridPainter(),
            ),
          ),

          // ── Main centre content ────────────────────────────────────────
          Center(
            child: _AnimatedContent(size: size),
          ),

          // ── Bottom loading section ─────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 52),
              child: _BottomSection(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles(Size size) {
    final rng = math.Random(42);
    return List.generate(18, (i) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 1.5 + rng.nextDouble() * 3.0;
      final opacity = 0.08 + rng.nextDouble() * 0.18;
      return Positioned(
        left: x,
        top: y,
        child: Container(
          width: r * 2,
          height: r * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: opacity),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated logo + title block
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedContent extends StatefulWidget {
  final Size size;
  const _AnimatedContent({required this.size});

  @override
  State<_AnimatedContent> createState() => _AnimatedContentState();
}

class _AnimatedContentState extends State<_AnimatedContent>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // Logo pop-in
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut)
        .drive(Tween(begin: 0.0, end: 1.0));
    _logoOpacity = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn)
        .drive(Tween(begin: 0.0, end: 1.0));

    // Text slide up
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textSlide = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut)
        .drive(Tween(begin: 30.0, end: 0.0));
    _textOpacity = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn)
        .drive(Tween(begin: 0.0, end: 1.0));

    // Subtle pulse on glow ring
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut)
        .drive(Tween(begin: 0.85, end: 1.08));

    // Sequence the animations
    _logoCtrl.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _textCtrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Logo with pulsing glow ring ──────────────────────────────
        AnimatedBuilder(
          animation: Listenable.merge([_logoCtrl, _pulseCtrl]),
          builder: (ctx, _) {
            return Opacity(
              opacity: _logoOpacity.value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: _logoScale.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow ring (pulsing)
                    Transform.scale(
                      scale: _pulse.value,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF34D399).withValues(alpha: 0.25),
                            width: 2,
                          ),
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF10B981).withValues(alpha: 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Middle ring
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1.5,
                        ),
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    // Icon container (inner)
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF34D399), Color(0xFF059669)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.5),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.volunteer_activism_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 28),

        // ── Brand name ───────────────────────────────────────────────
        AnimatedBuilder(
          animation: _textCtrl,
          builder: (ctx, child) {
            return Transform.translate(
              offset: Offset(0, _textSlide.value),
              child: Opacity(
                opacity: _textOpacity.value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              // Pill badge above title
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFF6EE7B7).withValues(alpha: 0.4),
                  ),
                  color: const Color(0xFF6EE7B7).withValues(alpha: 0.08),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF34D399),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Platform Relawan Indonesia',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA7F3D0),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // App title
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFA7F3D0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  'GoVolunter',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 46,
                    letterSpacing: -1.5,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tagline
              Text(
                'Bersama kita berdampak,\nsatu kegiatan relawan di satu waktu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.55,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom loading / version section
// ─────────────────────────────────────────────────────────────────────────────
class _BottomSection extends StatefulWidget {
  @override
  State<_BottomSection> createState() => _BottomSectionState();
}

class _BottomSectionState extends State<_BottomSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bar;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();
    _bar = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic)
        .drive(Tween(begin: 0.0, end: 1.0));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated loading bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: AnimatedBuilder(
              animation: _bar,
              builder: (ctx, _) {
                return Stack(
                  children: [
                    // Track
                    Container(
                      height: 3,
                      width: double.infinity,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    // Fill
                    FractionallySizedBox(
                      widthFactor: _bar.value,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6EE7B7), Color(0xFF34D399)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: 0.7),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Brand footer
        Text(
          'GoVolunter Community',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.white.withValues(alpha: 0.38),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'v1.0.0',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.white.withValues(alpha: 0.2),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Grid mesh painter
// ─────────────────────────────────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
