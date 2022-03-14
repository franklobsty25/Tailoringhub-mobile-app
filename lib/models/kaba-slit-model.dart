import 'package:flutter/foundation.dart';

class KabaSlitModel {
  final int contact;
  final int bust;
  final int waist;
  final int hip;
  final int shoulder;
  final int shoulderNipple;
  final int nippleNipple;
  final int napeWaist;
  final int shoulderWaist;
  final int shoulderHip;
  final int acrossChest;
  final int kabaLength;
  final int sleeveLength;
  final int aroundArm;
  final int acrossBack;
  final int slitLength;

  KabaSlitModel({
    @required this.contact,
    @required this.bust,
    @required this.waist,
    @required this.hip,
    @required this.shoulder,
    @required this.shoulderNipple,
    @required this.nippleNipple,
    @required this.napeWaist,
    @required this.shoulderWaist,
    @required this.shoulderHip,
    @required this.acrossChest,
    @required this.kabaLength,
    @required this.sleeveLength,
    @required this.aroundArm,
    @required this.acrossBack,
    @required this.slitLength,
  });

  Map<String, dynamic> toJson() {
    return {
      'contact': this.contact,
      'bust': this.bust,
      'waist': this.waist,
      'hip': this.hip,
      'shoulder': this.shoulder,
      'shoulder_nipple': this.shoulderNipple,
      'nipple_nipple': this.nippleNipple,
      'nape_waist': this.napeWaist,
      'shoulder_waist': this.shoulderWaist,
      'shoulder_hip': this.shoulderHip,
      'across_chest': this.acrossChest,
      'kaba_length': this.kabaLength,
      'sleeve_length': this.sleeveLength,
      'around_arm': this.aroundArm,
      'across_back': this.acrossBack,
      'slit_length': this.slitLength,
    };
  }

  static KabaSlitModel fromJson(Map<String, dynamic> json) {
    return KabaSlitModel(
      contact: json['id'],
      bust: json['bust'],
      waist: json['waist'],
      hip: json['hip'],
      shoulder: json['shoulder'],
      shoulderNipple: json['shoulder_nipple'],
      nippleNipple: json['nipple_nipple'],
      napeWaist: json['nape_waist'],
      shoulderWaist: json['shoulder_waist'],
      shoulderHip: json['shoulder_hip'],
      acrossChest: json['across_chest'],
      kabaLength: json['kaba_length'],
      sleeveLength: json['sleeve_length'],
      aroundArm: json['around_arm'],
      acrossBack: json['across_back'],
      slitLength: json['slit_length'],
    );
  }
}
