// To parse this JSON data, do
//
//     final roomTypeModel = roomTypeModelFromJson(jsonString);

import 'dart:convert';

List<RoomTypeModel> roomTypeModelFromJson(String str) =>
    List<RoomTypeModel>.from(json.decode(str).map((x) => RoomTypeModel.fromJson(x)));

String roomTypeModelToJson(List<RoomTypeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoomTypeModel {
  final int id;
  final int locationId;
  final String code;
  late String description;
  final bool isActive;
  final double rate;

  RoomTypeModel({
    required this.id,
    required this.locationId,
    required this.code,
    required this.description,
    required this.isActive,
    required this.rate,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) => RoomTypeModel(
        id: json["Id"],
        locationId: json["LocationId"],
        code: json["code"],
        description: json["description"],
        isActive: json["isActive"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "LocationId": locationId,
        "code": code,
        "description": description,
        "isActive": isActive,
        "rate": rate,
      };
}
