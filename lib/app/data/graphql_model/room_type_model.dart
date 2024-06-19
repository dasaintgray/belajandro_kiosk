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
  final Available available;

  RoomTypeModel({
    required this.id,
    required this.code,
    required this.locationId,
    required this.description,
    required this.available,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) => RoomTypeModel(
        id: json["Id"],
        code: json["code"],
        locationId: json["LocationId"],
        description: json["description"],
        available: Available.fromJson(json["available"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "LocationId": locationId,
        "description": description,
        "available": available.toJson(),
      };
}

class Available {
  final Total total;

  Available({
    required this.total,
  });

  factory Available.fromJson(Map<String, dynamic> json) => Available(
        total: Total.fromJson(json["total"]),
      );

  Map<String, dynamic> toJson() => {
        "total": total.toJson(),
      };
}

class Total {
  final int count;

  Total({
    required this.count,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}
