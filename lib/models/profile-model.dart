import 'package:flutter/foundation.dart';

class ProfileModel {
  final String about;
  final String company;
  final String job;
  final String country;
  final String address;
  final int phone;
  final String image;
  final String facebook;
  final String instagram;
  final String twitter;

  ProfileModel({
    @required this.about,
    @required this.company,
    @required this.job,
    @required this.country,
    @required this.address,
    @required this.phone,
    @required this.image,
    @required this.facebook,
    @required this.instagram,
    @required this.twitter,
  });

  Map<String, dynamic> toJson() {
    return {
      'about': this.about,
      'company': this.company,
      'job': this.job,
      'country': this.country,
      'address': this.address,
      'phone': this.phone,
      'image': this.image,
      'facebook': this.facebook,
      'instagram': this.instagram,
      'twitter': this.twitter,
    };
  }

  static ProfileModel fromJson(Map<String, dynamic> json) {
    return new ProfileModel(
      about: json['about'],
      company: json['company'],
      job: json['job'],
      country: json['country'],
      address: json['address'],
      phone: json['phone'],
      image: json['image'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      twitter: json['twitter'],
    );
  }
}
