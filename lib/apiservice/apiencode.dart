import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class ApiEncode {

  static String apiKey = 'viaviweb';
  static int salt = 0;

  static String generateMd5() {
    salt = generateRandomNumber();
    return md5.convert(utf8.encode(apiKey + salt.toString())).toString();
  }

  static String generateBase64(String input) {
    return base64.encode(utf8.encode(input)).toString();
  }

  static int generateRandomNumber() {
    return Random().nextInt(999);
  }

  static Map<String, String> getSignSalt() {
    return <String, String> {
      "sign": generateMd5(),
      "salt": salt.toString()
    };
  }
}
