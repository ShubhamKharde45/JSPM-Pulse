import 'package:jspm_pulse/features/auth/data/DataSource/supabase_auth_datasource.dart';
import 'package:jspm_pulse/features/auth/data/Models/user_model.dart';
import 'package:jspm_pulse/features/auth/domain/Entities/user_entity.dart';
import 'package:jspm_pulse/features/auth/domain/Repositories/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl extends AuthRepository {
  final SupabaseAuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = datasource.getCurrentUser();
    if (user != null) {
      return UserModel.fromSupabaseUser(user);
    }
    return null;
  }

  @override
  Future<UserEntity?> logIn(String email, String pwd) async {
    final user = await datasource.logIn(email, pwd);
    if (user != null) {
      return UserModel.fromSupabaseUser(user);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await datasource.signOut();
  }

  @override
  Future<UserEntity?> signUp(String email, String pwd) async {
    final user = await datasource.signUp(email, pwd);

    if (user != null) {
      return UserModel.fromSupabaseUser(user);
    }
    return null;
  }

  
  @override
  Future<String?> getCurrentUserRole() async{
    return await datasource.getCurrentUserRole();
  }
  
 
@override
Future<void> addRoleToDB(String role, String userId) async {
  await datasource.addRoleToDB(role, userId);
}

}
