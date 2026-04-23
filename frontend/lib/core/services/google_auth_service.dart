import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<String?> signIn() async {
    final account = await _googleSignIn.signIn();

    if (account == null) return null;

    final auth = await account.authentication;

    return auth.idToken; // 🔥 ini yang dikirim ke backend
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}