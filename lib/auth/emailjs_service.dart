import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class EmailJSService {
  static const String serviceId = 'service_misciko';
  static const String templateId = 'template_uttt8se';
  static const String publicKey = 'Hp5a3BNc7u2uYIPjI';

  /// Generates a secure 6-digit OTP
  static String generateOTP() {
    final random = Random.secure();
    // Generates a number between 100000 and 999999
    final otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }

  /// Sends the OTP via EmailJS API.
  /// Ensure that in your EmailJS Template dashboard, the 'To Email'
  /// field is set to {{to_email}} so it sends to the correct user.
  static Future<bool> sendOTP({
    required String userName,
    required String userEmail,
    required String otpCode,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'user_name': userName,
            'to_email': userEmail, // IMPORTANT: EmailJS template must use {{to_email}} in the "To" field!
            'otp_code': otpCode,
          }
        }),
      );

      if (response.statusCode == 200) {
        return true; // Sent successfully
      } else {
        print('EmailJS Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Failed to send OTP via EmailJS: $e');
      return false;
    }
  }
}
