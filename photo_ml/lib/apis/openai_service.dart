import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class OpenAIAPI {
  final List<Map<String, String>> messages = [];

  Future<String> makeAPICall(String prompt) async {
    if (prompt.contains('picture') ||
        prompt.contains('photo') ||
        prompt.contains('image') ||
        prompt.contains('art')) {
      return await dallEAPI(prompt);
    } else {
      return await chatGPTAPI(prompt);
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final resGPT = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (resGPT.statusCode == 200) {
        String content =
            jsonDecode(resGPT.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'Some errors occured! Baris chatGPT';
    } catch (e) {
      return e.toString();
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
