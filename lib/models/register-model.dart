import 'package:flutter/foundation.dart';

class RegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String deviceId;

  RegisterModel({
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.password,
    @required this.deviceId,
  });

  Map<String, String> toJson() {
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
      'password': this.password,
      'deviceId': this.deviceId,
    };
  }
}
