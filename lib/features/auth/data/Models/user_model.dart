import 'package:jspm_pulse/features/auth/domain/Entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends UserEntity {
  UserModel({super.email, required super.uid});

  factory UserModel.fromSupabaseUser(User user) =>
      UserModel(uid: user.id, email: user.email);
}
