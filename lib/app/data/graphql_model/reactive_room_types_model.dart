// To parse this JSON data, do
//
//     final reactiveRoomTypesModel = reactiveRoomTypesModelFromJson(jsonString);

import 'dart:convert';

List<ReactiveRoomTypesModel> reactiveRoomTypesModelFromJson(String str) =>
    List<ReactiveRoomTypesModel>.from(json.decode(str).map((x) => ReactiveRoomTypesModel.fromJson(x)));

String reactiveRoomTypesModelToJson(List<ReactiveRoomTypesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReactiveRoomTypesModel {
  final int id;
  final String code;
  final int locationId;
  String description;
  final String remarks;
  final String picture;
  final List<Price> price;
  final Available available;

  ReactiveRoomTypesModel({
    required this.id,
    required this.code,
    required this.locationId,
    required this.description,
    required this.remarks,
    required this.picture,
    required this.price,
    required this.available,
  });

  factory ReactiveRoomTypesModel.fromJson(Map<String, dynamic> json) => ReactiveRoomTypesModel(
        id: json["Id"],
        code: json["code"],
        locationId: json["LocationId"],
        description: json["description"],
        remarks: json["remarks"],
        picture: json["picture"],
        price: List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
        available: Available.fromJson(json["available"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "LocationId": locationId,
        "description": description,
        "remarks": remarks,
        "picture": picture,
        "price": List<dynamic>.from(price.map((x) => x.toJson())),
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
        "count": count.toInt(),
      };
}

class Price {
  final double rate;

  Price({
    required this.rate,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate.toDouble(),
      };
}
