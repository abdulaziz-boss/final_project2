import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initializing splash controller if not already initialized
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00301E), // Deep dark green
                  Color(0xFF004D34), // Rich emerald green
                  Color(0xFF006C49), // Signature brand green
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Glowing Decorative Circles in the Background
          Positioned(
            top: -50,
            left: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF10B981).withOpacity(0.15),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -80,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00F0FF).withOpacity(0.08),
                ),
              ),
            ),
          ),

          // Central Logo and Branding Content
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1600),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with outer glow and border
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volunteer_activism,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // App Title
                  const Text(
                    'zakkal.apl',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 42,
                      letterSpacing: -1.0,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tagline
                  Text(
                    'Platform Aksi Sosial & Relawan',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: const Color(0xFFA7F3D0).withOpacity(0.85),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Section: Loading indicator & Version info
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sleek Custom Linear Progress Indicator or Spurt Spinner
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.white.withOpacity(0.15),
                    ),
                  ),
                  const SizedBox(height: 36),
                  
                  // Footer info
                  Text(
                    'zakkal community',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
