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
}
