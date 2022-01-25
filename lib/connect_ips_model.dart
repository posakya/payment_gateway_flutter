// To parse this JSON data, do
//
//     final connectIpsRes = connectIpsResFromJson(jsonString);

import 'dart:convert';

ConnectIpsRes connectIpsResFromJson(String str) =>
    ConnectIpsRes.fromJson(json.decode(str));

String connectIpsResToJson(ConnectIpsRes data) => json.encode(data.toJson());

class ConnectIpsRes {
  ConnectIpsRes({
    this.status,
    this.token,
  });

  bool? status;
  String? token;

  factory ConnectIpsRes.fromJson(Map<String, dynamic> json) => ConnectIpsRes(
        status: json["status"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
      };
}
