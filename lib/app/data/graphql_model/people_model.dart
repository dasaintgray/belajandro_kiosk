// To parse this JSON data, do
//
//     final peoplesModel = peoplesModelFromJson(jsonString);

import 'dart:convert';

List<PeoplesModel> peoplesModelFromJson(String str) =>
    List<PeoplesModel>.from(json.decode(str).map((x) => PeoplesModel.fromJson(x)));

String peoplesModelToJson(List<PeoplesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PeoplesModel {
  final String fName;
  final String mName;
  final String lName;
  final String mobileNo;
  final String email;
  final String? code;
  final String name;

  PeoplesModel({
    required this.fName,
    required this.mName,
    required this.lName,
    required this.mobileNo,
    required this.email,
    required this.code,
    required this.name,
  });

  factory PeoplesModel.fromJson(Map<String, dynamic> json) => PeoplesModel(
        fName: json["fName"],
        mName: json["mName"],
        lName: json["lName"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        code: json["code"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "fName": fName,
        "mName": mName,
        "lName": lName,
        "mobileNo": mobileNo,
        "email": email,
        "code": code,
        "Name": name,
      };
}
