import 'dart:convert';

/// Simple XOR-based encryption for demonstration purposes.
class Encryption {
  static const _key = 0x42; // Example key. Replace with a secure key in prod.

  static String encrypt(String input) {
    final bytes = utf8.encode(input);
    final encrypted = bytes.map((b) => b ^ _key).toList();
    return base64Encode(encrypted);
  }

  static String decrypt(String encoded) {
    final bytes = base64Decode(encoded);
    final decrypted = bytes.map((b) => b ^ _key).toList();
    return utf8.decode(decrypted);
  }
}
