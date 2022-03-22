import 'dart:convert';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Customer extends StatefulWidget {
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _collectionDate = TextEditingController();
  final TextEditingController _charge = TextEditingController();
  final TextEditingController _advance = TextEditingController();
  final TextEditingController _balance = TextEditingController();
  final TextEditingController _style = TextEditingController();
  final TextEditingController _materialType = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _firstName.text = '';
    _lastName.text = '';
    _contact.text = '';
    _address.text = '';
    _collectionDate.text = '';
    _charge.text = '';
    _advance.text = '';
    _balance.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _contact.dispose();
    _address.dispose();
    _collectionDate.dispose();
    _charge.dispose();
    _advance.dispose();
    _balance.dispose();
    _style.dispose();
    _materialType.dispose();
    super.dispose();
  }

  void _getCollectionDate(context) async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      _collectionDate.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

// Saving customer information to database
  void _saveCustomerInfo() async {
    // Validation
    final isValid = _formKey.currentState.validate();
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      CustomerModel customer = new CustomerModel(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        contact: int.parse(_contact.text.trim()),
        address: _address.text.trim(),
        collectionDate: _collectionDate.text.trim(),
        charge: int.parse(_charge.text.trim()),
        advance: (_advance.text == '') ? 0 : int.parse(_advance.text.trim()),
        balance: (_balance.text == '') ? 0 : int.parse(_balance.text.trim()),
        style: _style.text.trim(),
        materialType: _materialType.text.trim(),
      );

      // Reading data from the 'token' key. If it doesn't exist, returns null.
      final String token = prefs.getString('token');

      try {
        final response = await http.post(
            Uri.parse(
                'https://tailoringhub.colonkoded.com/api/create/customer'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(customer.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            Navigator.of(context).pushReplacementNamed(
              '/choose',
              arguments: customer,
            );
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text(
                'Something went wrong. Please try again!',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (ex) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text(
              'Customer with that contact already exist.',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Measurement",
        bgColor: Colors.blue,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Measurement"),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/img/tailoringhub.jpg"),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 36.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 8.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: const Text("Customer Info",
                          style: TextStyle(
                              color: ArgonColors.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                                controller: _firstName,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  icon: const Icon(Icons.person),
                                ),
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter first name';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _lastName,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                  icon: const Icon(Icons.person),
                                ),
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter last name';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _contact,
                                decoration: const InputDecoration(
                                  labelText: 'Contact',
                                  icon: const Icon(Icons.contact_phone),
                                ),
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter contact number';
                                  }
                                  if (value.length < 10 || value.length > 10) {
                                    return 'Please contact must be at least 10 digits';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _address,
                                decoration: const InputDecoration(
                                  labelText: 'Address/Location',
                                  icon: const Icon(Icons.map),
                                ),
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter address/location';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _collectionDate,
                                decoration: const InputDecoration(
                                  labelText: 'Date of Collection',
                                  icon: const Icon(Icons.calendar_today),
                                ),
                                readOnly: true,
                                onTap: () {
                                  _getCollectionDate(context);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select collection date';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                controller: _charge,
                                decoration: const InputDecoration(
                                  labelText: 'Fee Charge GHS',
                                  icon: const Icon(Icons.money),
                                ),
                                enableSuggestions: true,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter fee charge';
                                  }
                                  return null;
                                }),
                            TextFormField(
                              controller: _advance,
                              decoration: const InputDecoration(
                                labelText: 'Advance paid GHS',
                                icon: const Icon(Icons.money),
                              ),
                              enableSuggestions: true,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _balance,
                              decoration: const InputDecoration(
                                labelText: 'Balance left GHS',
                                icon: const Icon(Icons.money),
                              ),
                              enableSuggestions: true,
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _style,
                              decoration: const InputDecoration(
                                labelText: 'Style',
                                icon: const Icon(Icons.style),
                              ),
                              autocorrect: true,
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.words,
                            ),
                            TextFormField(
                              controller: _materialType,
                              decoration: const InputDecoration(
                                labelText: 'Material Type',
                                icon: const Icon(Icons.design_services),
                              ),
                              autocorrect: true,
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 25.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: (_isLoading)
                                    ? const SizedBox(
                                        width: double.infinity,
                                        child: const SpinKitFadingCircle(
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      )
                                    : const Text(
                                        'Save & Continue',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0),
                                      ),
                                onPressed: _saveCustomerInfo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
