import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
Future sendingmail({
  required String name,
  required String email,
  required String subject,
  required String message,
}) async {
  final serviceId = 'service_r7dhupk';
  final templateId = 'template_xwvj42x';
  final userId = '7mJ2R_-Khlx7l0ysl';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': name,
        'user_email': email,
        'user_subject': subject,
        'user_message': message,
      }
    }),
  );
  print(response.body);
}

String createCode() {
  const String characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  String randomString = '';

  for (int i = 0; i < 5; i++) {
    int randomIndex = random.nextInt(characters.length);
    randomString += characters[randomIndex];
  }
  return randomString;
}