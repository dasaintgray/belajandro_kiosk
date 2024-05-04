// To parse this JSON data, do
//
//     final prefixModel = prefixModelFromJson(jsonString);

import 'dart:convert';

List<PrefixModel> prefixModelFromJson(String str) =>
    List<PrefixModel>.from(json.decode(str).map((x) => PrefixModel.fromJson(x)));

String prefixModelToJson(List<PrefixModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrefixModel {
  final int id;
  final String description;

  PrefixModel({
    required this.id,
    required this.description,
  });

  factory PrefixModel.fromJson(Map<String, dynamic> json) => PrefixModel(
        id: json["Id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "description": description,
      };
}
