import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class OpenAIAPI {
  final List<Map<String, String>> _chatMessages = [];

  Future<String> makeAPICall({required String prompt}) async {
    if (prompt.contains('picture') ||
        prompt.contains('photo') ||
        prompt.contains('image') ||
        prompt.contains('art')) {
      return await _dallEAPI(prompt: prompt);
    } else {
      return await _chatGPTAPI(prompt: prompt);
    }
  }

  Future<String> _chatGPTAPI({required String prompt}) async {
    _chatMessages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": _chatMessages,
        }),
      );

      if (response.statusCode == 200) {
        String content =
            jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        _chatMessages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      throw Exception('Failed to call ChatGPT API');
    } catch (e) {
      throw Exception('Failed to call ChatGPT API: $e');
    }
  }

  Future<String> _dallEAPI({required String prompt}) async {
    _chatMessages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final response = await http.post(
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
      if (response.statusCode == 200) {
        String resImageUrl = jsonDecode(response.body)['data'][0]['url'];
        resImageUrl = resImageUrl.trim();

        _chatMessages.add({
          'role': 'assistant',
          'content': resImageUrl,
        });

        return resImageUrl;
      }

      throw Exception('Failed to call Dall-E API');
    } catch (e) {
      throw Exception('Failed to call Dall-E API: $e');
    }
  }
}
