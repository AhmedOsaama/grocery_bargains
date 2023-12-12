import 'dart:convert';

BotResponse botResponseFromJson(String str) => BotResponse.fromJson(json.decode(str));
String botResponseToJson(BotResponse data) => json.encode(data.toJson());

class BotResponse {
  BotResponse({
    String? text,
  }) {
    _text = text;
  }

  BotResponse.fromJson(dynamic json) {
    _text = json['text'];
  }
  String? _text;
  BotResponse copyWith({
    String? text,
  }) =>
      BotResponse(
        text: text ?? _text,
      );
  String? get text => _text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['text'] = _text;
    return map;
  }
}
