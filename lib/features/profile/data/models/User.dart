import 'package:cloud_firestore/cloud_firestore.dart';

import 'Privacy.dart';
import 'Preferences.dart';

class AuthUser {
  AuthUser({
      String? email, 
      String? username, 
      String? imageURL, 
      String? phoneNumber, 
      String? token, 
      num? messageTokens, 
      Timestamp? timestamp,
      String? language, 
      String? status, 
      Privacy? privacy, 
      Preferences? preferences,}){
    _email = email;
    _username = username;
    _imageURL = imageURL;
    _phoneNumber = phoneNumber;
    _token = token;
    _messageTokens = messageTokens;
    _timestamp = timestamp;
    _language = language;
    _status = status;
    _privacy = privacy;
    _preferences = preferences;
}

  AuthUser.fromJson(dynamic json) {
    _email = json['email'];
    _username = json['username'];
    _imageURL = json['imageURL'];
    _phoneNumber = json['phoneNumber'];
    _token = json['token'];
    _messageTokens = json['message_tokens'];
    _timestamp = json['timestamp'];
    _language = json['language'];
    _status = json['status'];
    _privacy = json['privacy'] != null ? Privacy.fromJson(json['privacy']) : null;
    _preferences = json['preferences'] != null ? Preferences.fromJson(json['preferences']) : null;
  }
  String? _email;
  String? _username;
  String? _imageURL;
  String? _phoneNumber;
  String? _token;
  num? _messageTokens;
  Timestamp? _timestamp;
  String? _language;
  String? _status;
  Privacy? _privacy;
  Preferences? _preferences;
AuthUser copyWith({  String? email,
  String? username,
  String? imageURL,
  String? phoneNumber,
  String? token,
  num? messageTokens,
  Timestamp? timestamp,
  String? language,
  String? status,
  Privacy? privacy,
  Preferences? preferences,
}) => AuthUser(  email: email ?? _email,
  username: username ?? _username,
  imageURL: imageURL ?? _imageURL,
  phoneNumber: phoneNumber ?? _phoneNumber,
  token: token ?? _token,
  messageTokens: messageTokens ?? _messageTokens,
  timestamp: timestamp ?? _timestamp,
  language: language ?? _language,
  status: status ?? _status,
  privacy: privacy ?? _privacy,
  preferences: preferences ?? _preferences,
);
  String? get email => _email;
  String? get username => _username;
  String? get imageURL => _imageURL;
  String? get phoneNumber => _phoneNumber;
  String? get token => _token;
  num? get messageTokens => _messageTokens;
  Timestamp? get timestamp => _timestamp;
  String? get language => _language;
  String? get status => _status;
  Privacy? get privacy => _privacy;
  Preferences? get preferences => _preferences;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['username'] = _username;
    map['imageURL'] = _imageURL;
    map['phoneNumber'] = _phoneNumber;
    map['token'] = _token;
    map['message_tokens'] = _messageTokens;
    map['timestamp'] = _timestamp;
    map['language'] = _language;
    map['status'] = _status;
    if (_privacy != null) {
      map['privacy'] = _privacy?.toJson();
    }
    if (_preferences != null) {
      map['preferences'] = _preferences?.toJson();
    }
    return map;
  }

}