import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class OpenRouterService {
  static const String _apiKey = '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';
  static const String _endpoint = 'https://openrouter.ai/api/v1/chat/completions';

  /// Verifies if the image contains the expected medication.
  /// Returns a tuple: (bool isVerified, String reason)
  Future<(bool, String)> verifyMedicine(List<int> imageBytes, String expectedMedicineName) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://elderease.app', // OpenRouter requires a referer
          'X-Title': 'ElderEase App',
        },
        body: jsonEncode({
          'model': 'openai/gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': expectedMedicineName == 'Scan Medicine'
                      ? "You are a medical assistant. The user is scanning a medicine. Identify the medicine, pill, or box in the image. If you can clearly see any medicine or medicine packaging, respond strictly starting with 'YES' followed by a brief sentence identifying it. If no medicine is visible, respond strictly starting with 'NO' and a brief reason."
                      : "You are a medical assistant for an elderly care application. The user is supposed to be taking '${expectedMedicineName}'. Look at the image provided. Does the image show this medication, its packaging, pill bottle, or box? If the label or box matches '${expectedMedicineName}', it is correct. Respond strictly starting with 'YES' or 'NO', followed by a brief reason (max 2 sentences). Example: 'YES. The image clearly shows a box labeled with this medicine name.'",
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,${base64Image}',
                  },
                },
              ],
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final replyText = data['choices'][0]['message']['content'] as String;
        
        final upperReply = replyText.toUpperCase();
        if (upperReply.startsWith('YES')) {
          return (true, replyText);
        } else if (upperReply.startsWith('NO')) {
          return (false, replyText);
        } else {
          // If it doesn't clearly start with YES or NO, try to interpret or default to false
          return (upperReply.contains('YES'), replyText);
        }
      } else {
        debugPrint("OpenRouter API Error: \${response.statusCode} - \${response.body}");
        return (false, "Server error " + response.statusCode.toString() + ": " + response.body);
      }
    } catch (e) {
      debugPrint("OpenRouter Exception: \$e");
      return (false, "An error occurred while analyzing the image. Please check your connection.");
    }
  }
}

final openRouterService = OpenRouterService();
