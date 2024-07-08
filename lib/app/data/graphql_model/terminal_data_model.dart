// To parse this JSON data, do
//
//     final terminalDataModel = terminalDataModelFromJson(jsonString);

import 'dart:convert';

List<TerminalDataModel> terminalDataModelFromJson(String str) =>
    List<TerminalDataModel>.from(json.decode(str).map((x) => TerminalDataModel.fromJson(x)));

String terminalDataModelToJson(List<TerminalDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TerminalDataModel {
  final int id;
  final int terminalId;
  final String code;
  final String meta;
  final String status;
  final String value;

  TerminalDataModel({
    required this.id,
    required this.terminalId,
    required this.code,
    required this.meta,
    required this.status,
    required this.value,
  });

  factory TerminalDataModel.fromJson(Map<String, dynamic> json) => TerminalDataModel(
        id: json["Id"],
        terminalId: json["TerminalId"],
        code: json["code"],
        meta: json["meta"],
        status: json["status"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "TerminalId": terminalId,
        "code": code,
        "meta": meta,
        "status": status,
        "value": value,
      };
}
