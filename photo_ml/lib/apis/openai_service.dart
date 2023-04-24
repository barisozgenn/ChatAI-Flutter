import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class OpenAIAPI {
  final List<Map<String, String>> messages = [];

  Future<String> makeAPICall(String prompt) async {
    if (prompt.contains('photo') ||
        prompt.contains('image') ||
        prompt.contains('art')) {
      return await dallEAPI(prompt);
    } else {
      return await chatGPTAPI(prompt);
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    if (kDebugMode) {
      print('prompt: $prompt');
    }
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse(openAIAPIURL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content': messages,
            }
          ]
        }),
      );
      if (res.statusCode == 200) {
        String resContent =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        resContent = resContent.trim();

        messages.add({
          'role': 'assistant',
          'content': resContent,
        });
        print('resContent: $resContent');
        return resContent;
      }

      return 'Some errors occured! Baris chat GPT';
    } catch (ex) {
      print('error: $ex');
      return ex.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse(openAIImageAPIURL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
        }),
      );
      if (res.statusCode == 200) {
        String resImageUrl = jsonDecode(res.body)['data'][0]['url'];
        resImageUrl = resImageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': resImageUrl,
        });

        return resImageUrl;
      }

      return 'Some errors occured! Baris IMG';
    } catch (ex) {
      return ex.toString();
    }
  }
}
