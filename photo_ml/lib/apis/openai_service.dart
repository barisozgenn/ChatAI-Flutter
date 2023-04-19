import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/secrets.dart';

class OpenAIAPI {
  Future<String> isImagePromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content': 'This message is image content? $prompt : Yes or No',
            }
          ]
        }),
      );
      if (kDebugMode) {
        print(res.body);
        if (res.statusCode == 200) {
          String resContent =
              jsonDecode(res.body)['choices'][0]['message']['content'];
          resContent = resContent.trim();
          switch (resContent.toLowerCase()) {
            case 'yes':
            case 'yes.':
              final apiRes = await dallEAPI(prompt);
              return apiRes;
            default:
              return await chatGPTAPI(prompt);
          }
        }
      }

      return 'Some errors occured! Baris';
    } catch (ex) {
      return ex.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    return 'chatGPT';
  }

  Future<String> dallEAPI(String prompt) async {
    return 'dallE';
  }
}
