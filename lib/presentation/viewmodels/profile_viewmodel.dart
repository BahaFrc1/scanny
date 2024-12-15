import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user.dart';

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, User?>(
  (ref) => ProfileViewModel(),
);

class ProfileViewModel extends StateNotifier<User?> {
  ProfileViewModel()
      : super(User(
            id: "12",
            displayName: "name",
            email: "email",
            photoURL:
                "https://cdn-icons-png.flaticon.com/512/5969/5969702.png"));

  Future<void> signInWithGoogle() async {
    try {
      state = User(
          id: "12",
          displayName: "name",
          email: "email",
          photoURL: "https://cdn-icons-png.flaticon.com/512/5969/5969702.png");
    } catch (e) {
      print("Sign-In Error: $e");
    }
  }
}
