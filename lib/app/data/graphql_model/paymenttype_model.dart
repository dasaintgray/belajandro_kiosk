// To parse this JSON data, do
//
//     final paymentTypeModel = paymentTypeModelFromJson(jsonString);

import 'dart:convert';

List<PaymentTypeModel> paymentTypeModelFromJson(String str) =>
    List<PaymentTypeModel>.from(json.decode(str).map((x) => PaymentTypeModel.fromJson(x)));

String paymentTypeModelToJson(List<PaymentTypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentTypeModel {
  final int id;
  final String code;
  String description;

  PaymentTypeModel({
    required this.id,
    required this.code,
    required this.description,
  });

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) => PaymentTypeModel(
        id: json["Id"],
        code: json["code"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "code": code,
        "description": description,
      };
}
