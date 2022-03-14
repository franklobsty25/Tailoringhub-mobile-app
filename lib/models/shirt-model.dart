import 'package:flutter/foundation.dart';

class ShirtModel {
  final int contact;
  final int length;
  final int chest;
  final int back;
  final int sleeve;
  final int aroundArm;
  final int cuff;
  final int collar;
  final int acrossChest;

  ShirtModel({
    @required this.contact,
    @required this.length,
    @required this.chest,
    @required this.back,
    @required this.sleeve,
    @required this.aroundArm,
    @required this.cuff,
    @required this.collar,
    @required this.acrossChest,
  });

  Map<String, dynamic> toJson() {
    return {
      'contact': this.contact,
      'length': this.length,
      'chest': this.chest,
      'back': this.back,
      'sleeve': this.sleeve,
      'around_arm': this.aroundArm,
      'cuff': this.cuff,
      'collar': this.collar,
      'across_chest': this.acrossChest,
    };
  }

  static ShirtModel fromJson(Map<String, dynamic> json) {
    return ShirtModel(
      contact: json['id'],
      length: json['length'],
      chest: json['chest'],
      back: json['back'],
      sleeve: json['sleeve'],
      aroundArm: json['around_arm'],
      cuff: json['cuff'],
      collar: json['collar'],
      acrossChest: json['across_chest'],
    );
  }
}
