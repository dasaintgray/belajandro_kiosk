// To parse this JSON data, do
//
//     final settingsAndTranslationModel = settingsAndTranslationModelFromJson(jsonString);

import 'dart:convert';

SettingsAndTranslationModel settingsAndTranslationModelFromJson(String str) =>
    SettingsAndTranslationModel.fromJson(json.decode(str));

String settingsAndTranslationModelToJson(SettingsAndTranslationModel data) => json.encode(data.toJson());

class SettingsAndTranslationModel {
  final Data data;

  SettingsAndTranslationModel({
    required this.data,
  });

  factory SettingsAndTranslationModel.fromJson(Map<String, dynamic> json) => SettingsAndTranslationModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<Setting> settings;
  final List<Translation> translations;

  Data({
    required this.settings,
    required this.translations,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        settings: List<Setting>.from(json["Settings"].map((x) => Setting.fromJson(x))),
        translations: List<Translation>.from(json["Translations"].map((x) => Translation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Settings": List<dynamic>.from(settings.map((x) => x.toJson())),
        "Translations": List<dynamic>.from(translations.map((x) => x.toJson())),
      };
}

class Setting {
  final String code;
  final String value;
  final String description;

  Setting({
    required this.code,
    required this.value,
    required this.description,
  });

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        code: json["code"],
        value: json["value"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "value": value,
        "description": description,
      };
}

class Translation {
  final int id;
  final int languageId;
  final String code;
  final String description;
  final String translationText;
  final String images;
  final String type;

  Translation({
    required this.id,
    required this.languageId,
    required this.code,
    required this.description,
    required this.translationText,
    required this.images,
    required this.type,
  });

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["Id"],
        languageId: json["LanguageId"],
        code: json["code"],
        description: json["description"],
        translationText: json["translationText"],
        images: json["images"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "LanguageId": languageId,
        "code": code,
        "description": description,
        "translationText": translationText,
        "images": images,
        "type": type,
      };
}
