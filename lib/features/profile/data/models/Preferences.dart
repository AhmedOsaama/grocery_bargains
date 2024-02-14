class Preferences {
  Preferences({
      bool? emailMarketing, 
      bool? weekly, 
      bool? daily,}){
    _emailMarketing = emailMarketing;
    _weekly = weekly;
    _daily = daily;
}

  Preferences.fromJson(dynamic json) {
    _emailMarketing = json['emailMarketing'];
    _weekly = json['weekly'];
    _daily = json['daily'];
  }
  bool? _emailMarketing;
  bool? _weekly;
  bool? _daily;
Preferences copyWith({  bool? emailMarketing,
  bool? weekly,
  bool? daily,
}) => Preferences(  emailMarketing: emailMarketing ?? _emailMarketing,
  weekly: weekly ?? _weekly,
  daily: daily ?? _daily,
);
  bool? get emailMarketing => _emailMarketing;
  bool? get weekly => _weekly;
  bool? get daily => _daily;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['emailMarketing'] = _emailMarketing;
    map['weekly'] = _weekly;
    map['daily'] = _daily;
    return map;
  }

}