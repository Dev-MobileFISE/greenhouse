import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.181:8000';
  static const _storage = FlutterSecureStorage();

  // ─── REGISTER ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> register({
    required String firstname,
    required String lastname,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: {'Content-Type': 'application/ld+json', 'Accept': 'application/ld+json'},
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'data': data};
    }
    return {'success': false, 'message': data['detail'] ?? 'Erreur d\'inscription'};
  }

  // ─── LOGIN ─────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await _storage.write(key: 'jwt_token', value: data['token']);
      await _storage.write(key: 'user_firstname', value: data['firstname'] ?? '');
      await _storage.write(key: 'user_lastname', value: data['lastname'] ?? '');
      await _storage.write(key: 'user_email', value: data['email'] ?? '');
      await _storage.write(key: 'user_id', value: data['id'].toString());
      return {'success': true, 'data': data};
    }
    return {'success': false, 'message': 'Email ou mot de passe incorrect'};
  }

  // ─── LOGOUT ────────────────────────────────────────────────
  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  // ─── GET TOKEN ─────────────────────────────────────────────
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // ─── GET USER INFO ─────────────────────────────────────────
  static Future<Map<String, String?>> getUserInfo() async {
    return {
      'firstname': await _storage.read(key: 'user_firstname'),
      'lastname': await _storage.read(key: 'user_lastname'),
      'email': await _storage.read(key: 'user_email'),
      'id': await _storage.read(key: 'user_id'),
    };
  }

  // ─── AUTHENTICATED REQUEST ─────────────────────────────────
  static Future<http.Response> authenticatedGet(String path) async {
    final token = await getToken();
    return http.get(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/ld+json',
      },
    );
  }
}
