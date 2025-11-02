import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDatasource {
  final SupabaseClient _supabaseClient;

  SupabaseAuthDatasource(this._supabaseClient);

  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }

  Future<User?> signUp(String email, String pwd) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: pwd,
    );

    return response.user;
  }

  Future<User?> logIn(String email, String pwd) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: pwd,
    );
    return response.user;
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }


Future<void> addRoleToDB(String role, String userId) async {
  final response = await _supabaseClient
      .from('users')
      .update({'role': role})
      .eq('id', userId)
      .select();

  if (response.isEmpty) {
    throw Exception("No user found with id: $userId");
  }
}


Future<String?> getCurrentUserRole() async {
  final user = _supabaseClient.auth.currentUser;
  if (user == null) return null;

  final data = await _supabaseClient
      .from('users')
      .select('role')
      .eq('id', user.id)
      .maybeSingle();

  return data?['role'] as String?;
}


}
