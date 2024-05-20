// To parse this JSON data, do
//
//     final seriesDetailsModel = seriesDetailsModelFromJson(jsonString);

import 'dart:convert';

List<SeriesDetailsModel> seriesDetailsModelFromJson(String str) =>
    List<SeriesDetailsModel>.from(json.decode(str).map((x) => SeriesDetailsModel.fromJson(x)));

String seriesDetailsModelToJson(List<SeriesDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SeriesDetailsModel {
  final int id;
  final int seriesId;
  final String docNo;
  final String description;
  final int locationId;
  final int moduleId;
  final bool isActive;
  final DateTime tranDate;

  SeriesDetailsModel({
    required this.id,
    required this.seriesId,
    required this.docNo,
    required this.description,
    required this.locationId,
    required this.moduleId,
    required this.isActive,
    required this.tranDate,
  });

  factory SeriesDetailsModel.fromJson(Map<String, dynamic> json) => SeriesDetailsModel(
        id: json["Id"],
        seriesId: json["SeriesId"],
        docNo: json["docNo"],
        description: json["description"],
        locationId: json["LocationId"],
        moduleId: json["ModuleId"],
        isActive: json["isActive"],
        tranDate: DateTime.parse(json["tranDate"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "SeriesId": seriesId,
        "docNo": docNo,
        "description": description,
        "LocationId": locationId,
        "ModuleId": moduleId,
        "isActive": isActive,
        "tranDate": tranDate.toIso8601String(),
      };
}
