// To parse this JSON data, do
//
//     final menuModel = menuModelFromJson(jsonString);

import 'dart:convert';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  final Data data;

  MenuModel({
    required this.data,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<Menu> menu;

  Data({
    required this.menu,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
      };
}

class Menu {
  final int id;
  final int languageId;
  final String code;
  final String description;
  String translationText;
  final String images;
  final String type;

  Menu({
    required this.id,
    required this.languageId,
    required this.code,
    required this.description,
    required this.translationText,
    required this.images,
    required this.type,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
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
