import 'dart:convert';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:flutter/foundation.dart';
import 'package:argon_flutter/models/shorts-trouser-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShortsTrouserProvider extends ChangeNotifier {
  ShortsTrouserModel _shortsTrouser;

  ShortsTrouserModel get shortsTrouser {
    return this._shortsTrouser;
  }

  Future<void> getShortsTrouser(CustomerModel customer) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    try {
      final response = await http.get(
          Uri.parse(
              'https://tailoringhub.colonkoded.com/api/customer/${customer.contact}/measurement'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          });
      final result = jsonDecode(response.body) as Map<String, dynamic>;

      if (result['success'] && result['shortsTrouser'] != null) {
        _shortsTrouser = ShortsTrouserModel.fromJson(result['shortsTrouser']);

        notifyListeners();
      } else {
        _shortsTrouser = null;
      }
    } catch (ex) {
      print(ex);
    }
  }
}
