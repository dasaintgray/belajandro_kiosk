// To parse this JSON data, do
//
//     final languagesModel = languagesModelFromJson(jsonString);

import 'dart:convert';

LanguagesModel languagesModelFromJson(String str) => LanguagesModel.fromJson(json.decode(str));

String languagesModelToJson(LanguagesModel data) => json.encode(data.toJson());

class LanguagesModel {
  final Data data;

  LanguagesModel({
    required this.data,
  });

  factory LanguagesModel.fromJson(Map<String, dynamic> json) => LanguagesModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<Language> languages;

  Data({
    required this.languages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        languages: List<Language>.from(json["Languages"].map((x) => Language.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Languages": List<dynamic>.from(languages.map((x) => x.toJson())),
      };
}

class Language {
  final int id;
  final dynamic code;
  final String description;
  final dynamic disclaimer;
  final dynamic flag;

  Language({
    required this.id,
    required this.code,
    required this.description,
    required this.disclaimer,
    required this.flag,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["Id"],
        code: json["code"],
        description: json["description"],
        disclaimer: json["disclaimer"],
        flag: json["flag"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "description": description,
        "disclaimer": disclaimer,
        "flag": flag,
      };
}
