import 'package:flutter/foundation.dart';

class SuitModel {
  final int contact;
  final int halfBack;
  final int shoulder;
  final int elbow;
  final int sleeve;
  final int chest;
  final int suitLength;

  SuitModel({
    @required this.contact,
    @required this.halfBack,
    @required this.shoulder,
    @required this.elbow,
    @required this.sleeve,
    @required this.chest,
    @required this.suitLength,
  });

  Map<String, dynamic> toJson() {
    return {
      'contact': this.contact,
      'half_back': this.halfBack,
      'shoulder': this.shoulder,
      'elbow': this.elbow,
      'sleeve': this.sleeve,
      'chest': this.chest,
      'suit_length': this.suitLength,
    };
  }

  static SuitModel fromJson(Map<String, dynamic> json) {
    return SuitModel(
      contact: json['id'],
      halfBack: json['half_back'],
      shoulder: json['shoulder'],
      elbow: json['elbow'],
      sleeve: json['sleeve'],
      chest: json['chest'],
      suitLength: json['suit_length'],
    );
  }
}
