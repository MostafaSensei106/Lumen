abstract class AuthService {
  Future<void> initialize();
  Future<bool> signInWithGoogle();
  Future<bool> signInWithApple();
  Future<void> signOut();
  bool get isAuthenticated;
  String? get currentUserId;
}
