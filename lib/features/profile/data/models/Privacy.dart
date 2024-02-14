class Privacy {
  Privacy({
      bool? connectContacts, 
      bool? locationServices,}){
    _connectContacts = connectContacts;
    _locationServices = locationServices;
}

  Privacy.fromJson(dynamic json) {
    _connectContacts = json['connectContacts'];
    _locationServices = json['locationServices'];
  }
  bool? _connectContacts;
  bool? _locationServices;
Privacy copyWith({  bool? connectContacts,
  bool? locationServices,
}) => Privacy(  connectContacts: connectContacts ?? _connectContacts,
  locationServices: locationServices ?? _locationServices,
);
  bool? get connectContacts => _connectContacts;
  bool? get locationServices => _locationServices;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['connectContacts'] = _connectContacts;
    map['locationServices'] = _locationServices;
    return map;
  }

}