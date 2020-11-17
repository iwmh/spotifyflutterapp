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
