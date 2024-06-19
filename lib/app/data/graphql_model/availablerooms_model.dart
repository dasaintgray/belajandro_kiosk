// To parse this JSON data, do
//
//     final availableRoomsModel = availableRoomsModelFromJson(jsonString);

import 'dart:convert';

List<AvailableRoomsModel> availableRoomsModelFromJson(String str) =>
    List<AvailableRoomsModel>.from(json.decode(str).map((x) => AvailableRoomsModel.fromJson(x)));

String availableRoomsModelToJson(List<AvailableRoomsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AvailableRoomsModel {
  final int id;
  final String code;
  final String description;
  final double rate;
  final String lockCode;
  final int bed;
  final int roomTypeId;
  final String roomType;

  AvailableRoomsModel({
    required this.id,
    required this.code,
    required this.description,
    required this.rate,
    required this.lockCode,
    required this.bed,
    required this.roomTypeId,
    required this.roomType,
  });

  factory AvailableRoomsModel.fromJson(Map<String, dynamic> json) => AvailableRoomsModel(
        id: json["Id"],
        code: json["code"],
        description: json["description"],
        rate: json["rate"],
        lockCode: json["lockCode"],
        bed: json["bed"],
        roomTypeId: json["RoomTypeId"],
        roomType: json["roomType"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "description": description,
        "rate": rate,
        "lockCode": lockCode,
        "bed": bed,
        "RoomTypeId": roomTypeId,
        "roomType": roomType,
      };
}
