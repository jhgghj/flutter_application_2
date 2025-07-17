import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 用户注册
  Future<UserCredential?> register(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Registration failed: ${e.message}');
      return null;
    }
  }

  // 用户登录
  Future<UserCredential?> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.message}');
      return null;
    }
  }

  // 获取当前用户
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // 用户退出
  Future<void> logout() async {
    await _auth.signOut();
  }
}
