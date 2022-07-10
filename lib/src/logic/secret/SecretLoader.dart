import 'dart:async' show Future;
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

import 'Secret.dart';

class SecretLoader {
  final String secretPath;

  SecretLoader({required this.secretPath});

  Future<Secret> load() async {
    final data = await rootBundle.loadString(secretPath);
    final secret = Secret.fromJson(json.decode(data));
    return secret;
  }
}
