import 'dart:convert';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/data/cases/api_client.dart';
import 'package:chat_mobile/data/entities/creadential.dart';
import 'package:chat_mobile/flavors/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String _cODE = 'code';
  final String _cREDENTIAL = 'credential';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  String authCode = '';

  static final AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  Future<bool> checkCode() async {
    await getCode();
    Credential credential = await getCredentials();
    if(authCode.isEmpty) return false;
    try {
      UsersClient usersClient = UsersClient(MobileApiClient());
      currentUser = await usersClient.login(credential.login, credential.password);
      return true;
    } on Exception catch (_) {
      debugPrint('Check auth failed');
    }
    return false;
  }

  Future<String> getCode() async {
    authCode = await storage.read(key: _cODE) ?? '';
    debugPrint('User code auth: $authCode');
    return authCode;
  }

  Future<void> saveCredential(String login, String password) =>
      storage.write(key: _cREDENTIAL, value: json.encode(Credential(login, password).json));

  Future<Credential> getCredentials() async {
    String res = await storage.read(key: _cREDENTIAL);
    if(res == null) return null;
    dynamic _json;
    try {
      _json = json.decode(res);
    } catch(e) {
      return null;
    }

    return Credential.fromJson(_json);
  }

  Future<void> logout() async {
    await storage.delete(key: _cODE);
    authCode = '';
    debugPrint('User code success removed');
  }

  Future<void> updateCode(String code) async {
    if(authCode == code) return;
    authCode = code;
    await storage.write(key: _cODE, value: code);
    debugPrint('User code success updated');
  }

}

AuthService authService = AuthService();