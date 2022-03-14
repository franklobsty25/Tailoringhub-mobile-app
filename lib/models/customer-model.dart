import 'package:flutter/foundation.dart';

class CustomerModel {
  final String firstName;
  final String lastName;
  final int contact;
  final String address;
  final String collectionDate;
  final int charge;
  final int advance;
  final int balance;
  final String style;
  final String materialType;

  CustomerModel({
    @required this.firstName,
    @required this.lastName,
    @required this.contact,
    @required this.address,
    @required this.collectionDate,
    @required this.charge,
    @required this.advance,
    @required this.balance,
    @required this.style,
    @required this.materialType,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'contact': this.contact,
      'address': this.address,
      'collectionDate': this.collectionDate,
      'charge': this.charge,
      'advance': this.advance,
      'balance': this.balance,
      'style': this.style,
      'materialType': this.materialType,
    };
  }

  static CustomerModel fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      contact: json["contact"],
      address: json["address"],
      collectionDate: json["collectionDate"],
      charge: json["charge"],
      advance: json["advance"],
      balance: json["balance"],
      style: json["style"],
      materialType: json["materialType"],
    );
  }
}
