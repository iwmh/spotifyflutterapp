import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:spotifyflutterapp/data/models/secrets.dart';

Future<String> loadSecrets() async {
  return await rootBundle.loadString('assets/secrets.json');
}

Future<Secrets> getSecretsFromAssets() async {
  var secretsStr = await loadSecrets();
  Map secretMap = jsonDecode(secretsStr);
  return Secrets.fromJson(secretMap);
}

// create code_challenge
String createCodeChallengeFromCodeVerifier(String code_verifier) {
  // sha256 hash the code_verifier
  var bytes = utf8.encode(code_verifier);
  var digest = sha256.convert(bytes);

  // base64 encode
  var code_challenge = base64.encode(digest.bytes.toList());

  // Remove any trailing '='s
  code_challenge = code_challenge.split('=')[0];
  // 62nd char of encoding
  code_challenge = code_challenge.replaceAll('+', '-');
  // 63rd char of encoding
  code_challenge = code_challenge.replaceAll('/', '_');

  return code_challenge;

}
