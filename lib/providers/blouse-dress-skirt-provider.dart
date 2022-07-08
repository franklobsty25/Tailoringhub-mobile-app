import 'dart:convert';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:flutter/foundation.dart';
import 'package:argon_flutter/models/blouse-dress-skirt-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BlouseDressSkirtProvider extends ChangeNotifier {
  BlouseDressSkirtModel _blouseDressSkirt;

  BlouseDressSkirtModel get blouseDressSkirt {
    return this._blouseDressSkirt;
  }

  Future<void> getBlouseDressSkirt(CustomerModel customer) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    final response = await http.get(
        Uri.parse(
            'https://tailoring.tailoringhub.colonkoded.com/api/customer/${customer.contact}/measurement'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json; charset=utf-8'
        });
    final result = jsonDecode(response.body) as Map<String, dynamic>;

    if (result['success'] && result['blouseDressSkirt'] != null) {
      _blouseDressSkirt =
          BlouseDressSkirtModel.fromJson(result['blouseDressSkirt']);
      notifyListeners();
    } else {
      _blouseDressSkirt = null;
    }
  }
}
