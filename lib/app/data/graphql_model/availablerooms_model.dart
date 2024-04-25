// To parse this JSON data, do
//
//     final availableRoomsModel = availableRoomsModelFromJson(jsonString);

import 'dart:convert';

AvailableRoomsModel availableRoomsModelFromJson(String str) => AvailableRoomsModel.fromJson(json.decode(str));

String availableRoomsModelToJson(AvailableRoomsModel data) => json.encode(data.toJson());

class AvailableRoomsModel {
  final Data data;

  AvailableRoomsModel({
    required this.data,
  });

  factory AvailableRoomsModel.fromJson(Map<String, dynamic> json) => AvailableRoomsModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<VRoomAvailable> vRoomAvailable;

  Data({
    required this.vRoomAvailable,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        vRoomAvailable: List<VRoomAvailable>.from(json["vRoomAvailable"].map((x) => VRoomAvailable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vRoomAvailable": List<dynamic>.from(vRoomAvailable.map((x) => x.toJson())),
      };
}

class VRoomAvailable {
  final int id;
  final String code;
  final String description;
  final int rate;
  final String lockCode;
  final int bed;

  VRoomAvailable({
    required this.id,
    required this.code,
    required this.description,
    required this.rate,
    required this.lockCode,
    required this.bed,
  });

  factory VRoomAvailable.fromJson(Map<String, dynamic> json) => VRoomAvailable(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        rate: json["rate"],
        lockCode: json["lockCode"],
        bed: json["bed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "rate": rate,
        "lockCode": lockCode,
        "bed": bed,
      };
}
