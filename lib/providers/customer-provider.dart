import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomerProvider extends ChangeNotifier {
  List<CustomerModel> _customers = [];

  List<CustomerModel> get customers {
    return [..._customers];
  }

  // Fetch customers that belong to user(tailor/seamstress)
  Future<void> getCustomers() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    try {
      final response = await http.get(
          Uri.parse('https://tailoringhub.colonkoded.com/api/customers'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          });
      final result = jsonDecode(response.body) as Map<String, dynamic>;

      _customers = (result['customers'] as List)
          .map((customer) => CustomerModel.fromJson(customer))
          .toList();

      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  // Search customer that belongs to user(tailor/seamstress)
  Future<void> searchCustomer(String contact) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    try {
      final response = await http.get(
          Uri.parse('https://tailoringhub.colonkoded.com/api/customer/search/' +
              contact),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          });
      final result = jsonDecode(response.body) as Map<String, dynamic>;

      _customers = (result['customer'] as List)
          .map((customer) => CustomerModel.fromJson(customer))
          .toList();

      notifyListeners();
    } catch (ex) {
      print(ex);
    }
  }

  // Delete customer that belongs to user(tailor/seamstress)
  Future<void> deleteCustomer(CustomerModel customer) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    try {
      final response = await http.delete(
          Uri.parse(
              'https://tailoringhub.colonkoded.com/api/delete/customer/${customer.contact}'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          });
      final result = jsonDecode(response.body) as Map<String, dynamic>;

      if (result['success']) {
        getCustomers();

        notifyListeners();
      }
    } catch (ex) {
      print(ex);
    }
  }
}
