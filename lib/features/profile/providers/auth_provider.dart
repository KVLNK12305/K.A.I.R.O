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
    state = await _apiService.signInSilently();
  }

  Future<void> login() async {
    state = await _apiService.signIn();
  }

  Future<void> logout() async {
    await _apiService.signOut();
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, GoogleSignInAccount?>((ref) {
  return AuthNotifier(ref.read(googleApiServiceProvider));
});
