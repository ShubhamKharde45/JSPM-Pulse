import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FCMService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final SupabaseClient _supabase = Supabase.instance.client;


  Future<void> initFCM() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      return;
    }


    await _saveToken();

    _fcm.onTokenRefresh.listen((token) async {
      await _updateToken(token);
    });
  }

  Future<void> _saveToken() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final token = await _fcm.getToken();
    if (token == null) return;

    await _updateToken(token);
  }

  Future<void> _updateToken(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('users')
        .update({
          'fcm_token': token,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        })
        .eq('id', user.id);
  }
}
