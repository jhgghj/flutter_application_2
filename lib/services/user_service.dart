import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 更新用户资料
  Future<void> updateNickname(String nickname) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(nickname);
      await user.reload();
    }
  }
}
