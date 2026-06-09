import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const apiKey = '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';
  const endpoint = 'https://openrouter.ai/api/v1/chat/completions';
  
  // Create a dummy 1x1 pixel JPEG base64 string
  const dummyBase64 = '/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP//////////////////////////////////////////////////////////////////////////////////////wgALCAABAAEBAREA/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPxA=';

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + apiKey,
      'HTTP-Referer': 'https://elderease.app',
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
              'text': "Is this medicine Aspirin?",
            },
            {
              'type': 'image_url',
              'image_url': {
                'url': 'data:image/jpeg;base64,' + dummyBase64,
              },
            },
          ],
        }
      ],
    }),
  );

  print('Status: ' + response.statusCode.toString());
  print('Body: ' + response.body);
}
