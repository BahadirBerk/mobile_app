import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for communicating with external AI APIs.
class AiApiService {
  final String apiKey;
  final http.Client _client;

  AiApiService({required this.apiKey, http.Client? client})
      : _client = client ?? http.Client();

  static const _baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> summarize(String text) async {
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': 'Summarize the following text'},
        {'role': 'user', 'content': text}
      ],
      'max_tokens': 100,
    });
    final resp = await _post(body);
    return resp;
  }

  Future<String> extractKeywords(String text) async {
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content':
              'Extract the main keywords from the following text as a comma separated list'
        },
        {'role': 'user', 'content': text}
      ],
      'max_tokens': 60,
    });
    final resp = await _post(body);
    return resp;
  }

  Future<String> generateQuestions(String text) async {
    final body = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content': 'Generate quiz questions from the following text'
        },
        {'role': 'user', 'content': text}
      ],
      'max_tokens': 150,
    });
    final resp = await _post(body);
    return resp;
  }

  Future<String> _post(String body) async {
    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>;
      final content = choices.first['message']['content'] as String;
      return content.trim();
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
