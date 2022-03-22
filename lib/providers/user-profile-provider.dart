import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:argon_flutter/models/user-model.dart';
import 'package:argon_flutter/models/profile-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserProfileProvider extends ChangeNotifier {
  UserModel _user;
  ProfileModel _profile;
  int _totalCustomers;

  UserModel get user {
    return this._user;
  }

  ProfileModel get profile {
    return this._profile;
  }

  int get totalCustomers {
    return this._totalCustomers;
  }

  Future<void> getUserProfile() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    final response = await http.get(
        Uri.parse('https://tailoringhub.colonkoded.com/api/profile'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json; charset=utf-8'
        });
    final result = jsonDecode(response.body) as Map<String, dynamic>;

    if (result['success']) {
      _user = UserModel.fromJson(result['user']);
      _profile = ProfileModel.fromJson(result['user']['detail']);
      _totalCustomers = result['totalCustomers'];
      notifyListeners();
    }
  }
}
