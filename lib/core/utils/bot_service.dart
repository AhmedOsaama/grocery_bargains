import 'dart:convert';

import 'package:dio/dio.dart';

class BotService{
  final _baseUrl = 'https://www.chatbase.co/api/v1/chat';
  final Dio _dio;

  BotService(this._dio);

  Future<Map<String, dynamic>> post({required String message}) async {
    var response = await _dio.post('$_baseUrl',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer 6423c502-7700-4dc6-b9ea-4d10da3b0a84'
          }
        ),
        data: jsonEncode({
      "messages": [
        { "content": "$message",
          "role": "assistant"
        }
      ],
      "chatbotId": "xkNyMYIGpTh7jGUu-XWbc",
      "stream": false,
      "model": "gpt-3.5-turbo",
      "temperature": 0
    }));
    return response.data;
  }

}