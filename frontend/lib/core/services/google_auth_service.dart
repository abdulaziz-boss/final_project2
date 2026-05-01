import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthService {
  static const String _clientId = '348758929726-nvd60mupci9lcr7acvagmcht9tstmnot.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _clientId : null,
    serverClientId: kIsWeb ? null : _clientId,
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.email',
      'openid',
      'profile',
    ],
  );

  Future<String?> signIn() async {
    try {
      if (kIsWeb) {
        await _googleSignIn.signOut();
      }

      final account = await _googleSignIn.signIn();

      if (account == null) {
        print("GOOGLE AUTH SERVICE: Akun null");
        return null;
      }

      final auth = await account.authentication;
      
      // 🔥 JIKA ID TOKEN NULL, GUNAKAN ACCESS TOKEN
      final token = auth.idToken ?? auth.accessToken;

      if (token == null) {
        print("GOOGLE AUTH SERVICE: Semua Token NULL!");
      } else {
        print("GOOGLE AUTH SERVICE: Berhasil dapat ${auth.idToken != null ? 'ID Token' : 'Access Token'}");
        print("TOKEN: $token"); // Log untuk debugging
      }

      return token;
    } catch (e) {
      print("GOOGLE AUTH SERVICE ERROR: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}