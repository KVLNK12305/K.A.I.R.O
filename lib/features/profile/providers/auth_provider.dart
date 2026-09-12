import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/services/google_api_service.dart';

final googleApiServiceProvider = Provider((ref) => GoogleApiService());

class AuthNotifier extends StateNotifier<GoogleSignInAccount?> {
  final GoogleApiService _apiService;

  AuthNotifier(this._apiService) : super(null) {
    _init();
  }

  Future<void> _init() async {
    final account = await _apiService.signInSilently();
    if (!mounted) return;
    state = account;
  }

  Future<void> login() async {
    final account = await _apiService.signIn();
    if (!mounted) return;
    state = account;
  }

  Future<void> logout() async {
    await _apiService.signOut();
    if (!mounted) return;
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, GoogleSignInAccount?>((ref) {
  return AuthNotifier(ref.read(googleApiServiceProvider));
});


