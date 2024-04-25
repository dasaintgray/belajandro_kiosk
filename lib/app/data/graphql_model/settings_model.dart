// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromJson(jsonString);

import 'dart:convert';

SettingsModel settingsModelFromJson(String str) => SettingsModel.fromJson(json.decode(str));

String settingsModelToJson(SettingsModel data) => json.encode(data.toJson());

class SettingsModel {
  final Data data;

  SettingsModel({
    required this.data,
  });

  SettingsModel copyWith({
    Data? data,
  }) =>
      SettingsModel(
        data: data ?? this.data,
      );

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<Setting> settings;

  Data({
    required this.settings,
  });

  Data copyWith({
    List<Setting>? settings,
  }) =>
      Data(
        settings: settings ?? this.settings,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        settings: List<Setting>.from(json["Settings"].map((x) => Setting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Settings": List<dynamic>.from(settings.map((x) => x.toJson())),
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

  Setting copyWith({
    String? code,
    String? value,
    String? description,
  }) =>
      Setting(
        code: code ?? this.code,
        value: value ?? this.value,
        description: description ?? this.description,
      );

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
