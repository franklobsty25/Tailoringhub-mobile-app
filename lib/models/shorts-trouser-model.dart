import 'package:flutter/foundation.dart';

class ShortsTrouserModel {
  final int contact;
  final int waist;
  final int length;
  final int thighs;
  final int bassBottom;
  final int seat;
  final int knee;
  final int flapFly;
  final int hip;
  final int waistKnee;

  ShortsTrouserModel({
    @required this.contact,
    @required this.waist,
    @required this.length,
    @required this.thighs,
    @required this.bassBottom,
    @required this.seat,
    @required this.knee,
    @required this.flapFly,
    @required this.hip,
    @required this.waistKnee,
  });

  Map<String, dynamic> toJson() {
    return {
      'contact': this.contact,
      'waist': this.waist,
      'length': this.length,
      'thighs': this.thighs,
      'bass_bottom': this.bassBottom,
      'seat': this.seat,
      'knee': this.knee,
      'flap_fly': this.flapFly,
      'hip': this.hip,
      'waist_knee': this.waistKnee,
    };
  }

  static ShortsTrouserModel fromJson(Map<String, dynamic> json) {
    return ShortsTrouserModel(
      contact: json['id'],
      waist: json['waist'],
      length: json['length'],
      thighs: json['thighs'],
      bassBottom: json['bass_bottom'],
      seat: json['seat'],
      knee: json['knee'],
      flapFly: json['flap_fly'],
      hip: json['hip'],
      waistKnee: json['waist_knee'],
    );
  }
}
