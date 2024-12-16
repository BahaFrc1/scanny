import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/profile.dart';
import '../../data/models/user.dart';

class ProfileViewModel extends StateNotifier<User?> {
  ProfileViewModel() : super(mockUser);
}
