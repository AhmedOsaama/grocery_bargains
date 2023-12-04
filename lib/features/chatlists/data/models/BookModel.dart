import 'Items.dart';
import 'dart:convert';

BookModel boookModelFromJson(String str) => BookModel.fromJson(json.decode(str));
String boookModelToJson(BookModel data) => json.encode(data.toJson());
class BookModel {
  BookModel({
      String? kind, 
      num? totalItems, 
      List<Items>? items,}){
    _kind = kind;
    _totalItems = totalItems;
    _items = items;
}

  BookModel.fromJson(dynamic json) {
    _kind = json['kind'];
    _totalItems = json['totalItems'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  String? _kind;
  num? _totalItems;
  List<Items>? _items;
BookModel copyWith({  String? kind,
  num? totalItems,
  List<Items>? items,
}) => BookModel(  kind: kind ?? _kind,
  totalItems: totalItems ?? _totalItems,
  items: items ?? _items,
);
  String? get kind => _kind;
  num? get totalItems => _totalItems;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kind'] = _kind;
    map['totalItems'] = _totalItems;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}