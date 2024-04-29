// To parse this JSON data, do
//
//     final roomTypeModel = roomTypeModelFromJson(jsonString);

import 'dart:convert';

List<RoomTypeModel> roomTypeModelFromJson(String str) =>
    List<RoomTypeModel>.from(json.decode(str).map((x) => RoomTypeModel.fromJson(x)));

String roomTypeModelToJson(List<RoomTypeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoomTypeModel {
  final int id;
  final String code;
  final int locationId;
  String description;

  RoomTypeModel({
    required this.id,
    required this.code,
    required this.locationId,
    required this.description,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) => RoomTypeModel(
        id: json["Id"],
        code: json["code"],
        locationId: json["LocationId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "LocationId": locationId,
        "description": description,
      };
}
