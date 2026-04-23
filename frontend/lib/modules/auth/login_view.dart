import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);

  final LoginController authC = Get.put(LoginController());
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final RxBool isObscure = true.obs;
  final RxBool isRemember = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // bg-surface
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
              child: Container(
                width: 384,
                height: 384,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF006C49).withOpacity(0.05),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0051D5).withOpacity(0.05),
                ),
              ),
            ),
          ),
          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF), // bg-surface-container-lowest
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04), // shadow-[0_40px_80px_rgba(0,0,0,0.04)]
                      offset: const Offset(0, 40),
                      blurRadius: 80,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildMainForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainForm() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      color: const Color(0xFFFFFFFF),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo (Mirip Instagram)
          const Center(
            child: Column(
              children: [
                Icon(Icons.volunteer_activism, color: Color(0xFF006C49), size: 48),
                SizedBox(height: 8),
                Text(
                  'zakkal.apl',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF191C1D),
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          // Email
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Email',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C4A42),
              ),
            ),
          ),
          _CustomTextField(
            controller: emailC,
            hintText: 'example@email.com',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          // Password
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kata Sandi',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C4A42),
                  ),
                ),
              ],
            ),
          ),
          Obx(() => _CustomTextField(
            controller: passC,
            hintText: '••••••••',
            icon: Icons.lock_outline,
            obscureText: isObscure.value,
            suffixIcon: IconButton(
               icon: Icon(
                 isObscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                 color: const Color(0xFF6C7A71),
                 size: 20,
               ),
               onPressed: () {
                 isObscure.value = !isObscure.value;
               },
            )
          )),
          const SizedBox(height: 24),
          // Submit
          Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF006C49), Color(0xFF10B981)], // primary to primary-container
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF006C49).withOpacity(0.2),
                  offset: const Offset(0, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: authC.isLoading.value ? null : () {
                  authC.login(emailC.text, passC.text);
                },
                child: Center(
                  child: authC.isLoading.value 
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Masuk',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
                ),
              ),
            ),
          )),
          const SizedBox(height: 24),
          // Divider "Atau"
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Atau',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF6C7A71),
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 24),
          // Google Login Button
          Obx(() => SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: authC.isLoading.value ? null : () {
                authC.loginWithGoogle();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                backgroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://img.icons8.com/color/48/000000/google-logo.png',
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Masuk dengan Google',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF3C4A42),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(height: 32),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Text(
                  'Belum punya akun? ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF3C4A42),
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/register');
                  },
                  child: const Text(
                    'Daftar sekarang',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF006C49),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const _CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<_CustomTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _isFocused ? const Color(0xFFE7E8E9) : const Color(0xFFF3F4F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF191C1D),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF6C7A71),
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _isFocused ? const Color(0xFF0051D5) : const Color(0xFF6C7A71),
                size: 20,
              ),
              suffixIcon: widget.suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 2,
                    width: _isFocused ? constraints.maxWidth : 0,
                    color: const Color(0xFF0051D5),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

