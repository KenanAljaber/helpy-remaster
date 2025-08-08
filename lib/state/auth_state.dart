import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple global auth state with token persistence.
class AuthState extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';

  String? _token;
  String? _userId;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  String? get token => _token;
  String? get userId => _userId;

  /// Load persisted token on app start
  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
    } catch (_) {
      // Fallback for environments where the plugin isn't ready (e.g., early web)
      _token = null;
    }
    // In a real app, decode token for user id. Here we fake it.
    _userId = isLoggedIn ? 'current_user' : null;
    notifyListeners();
  }

  /// Fake sign-in that stores a token and a dummy user id
  Future<void> signInWithFakeToken() async {
    _token = 'fake-token-${DateTime.now().millisecondsSinceEpoch}';
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _token!);
    } catch (_) {
      // Ignore persistence errors on unsupported platforms
    }
    _userId = 'current_user';
    notifyListeners();
  }

  /// Clear token and user info
  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } catch (_) {}
    _token = null;
    _userId = null;
    notifyListeners();
  }
}
