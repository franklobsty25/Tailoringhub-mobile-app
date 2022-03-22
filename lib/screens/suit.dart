import 'dart:convert';
import 'package:argon_flutter/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:argon_flutter/models/suit-model.dart';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argon_flutter/providers/suit-provider.dart';
import 'package:http/http.dart' as http;

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Suit extends StatefulWidget {
  @override
  State<Suit> createState() => _SuitState();
}

class _SuitState extends State<Suit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _halfBack = TextEditingController();
  final TextEditingController _shoulder = TextEditingController();
  final TextEditingController _elbow = TextEditingController();
  final TextEditingController _sleeve = TextEditingController();
  final TextEditingController _chest = TextEditingController();
  final TextEditingController _suitLength = TextEditingController();
  bool _isLoading = false;
  bool _isSuit = false;

  @override
  void initState() {
    SuitModel suit = Provider.of<SuitProvider>(context, listen: false).suit;
    (suit != null)
        ? _halfBack.text = suit.halfBack.toString()
        : _halfBack.text = '';
    (suit != null)
        ? _shoulder.text = suit.shoulder.toString()
        : _shoulder.text = '';
    (suit != null) ? _elbow.text = suit.elbow.toString() : _elbow.text = '';
    (suit != null) ? _sleeve.text = suit.sleeve.toString() : _sleeve.text = '';
    (suit != null) ? _chest.text = suit.chest.toString() : _chest.text = '';
    (suit != null)
        ? _suitLength.text = suit.suitLength.toString()
        : _suitLength.text = '';
    if (suit != null) {
      setState(() {
        _isSuit = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _halfBack.dispose();
    _shoulder.dispose();
    _elbow.dispose();
    _sleeve.dispose();
    _chest.dispose();
    _suitLength.dispose();
    super.dispose();
  }

// Save customer suit measurement
  _saveSuit() async {
    // Form validation
    final isValid = _formKey.currentState.validate();
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    CustomerModel customer =
        ModalRoute.of(context).settings.arguments as CustomerModel;

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      SuitModel suit = SuitModel(
        contact: customer.contact,
        halfBack: int.parse(_halfBack.text.trim()),
        shoulder: int.parse(_shoulder.text.trim()),
        elbow: int.parse(_elbow.text.trim()),
        sleeve: int.parse(_sleeve.text.trim()),
        chest: int.parse(_chest.text.trim()),
        suitLength: int.parse(_suitLength.text.trim()),
      );

      // Reading data from the 'token' key. If it doesn't exist, returns null.
      final String token = prefs.getString('token');

      try {
        final response = await http.post(
            Uri.parse('https://tailoringhub.colonkoded.com/api/create/suit'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(suit.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${customer.firstName} ${customer.lastName} suit measurement saved. Add another!',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: ArgonColors.success,
              ),
            );

            // Return back
            Navigator.of(context)
                .pushReplacementNamed('/choose', arguments: customer);
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
              'Something went wrong. Please try again!',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Update suit measurement
  _updateSuit() async {
    // Form validation
    final isValid = _formKey.currentState.validate();
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    CustomerModel customer =
        ModalRoute.of(context).settings.arguments as CustomerModel;

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      SuitModel suit = SuitModel(
        contact: customer.contact,
        halfBack: int.parse(_halfBack.text.trim()),
        shoulder: int.parse(_shoulder.text.trim()),
        elbow: int.parse(_elbow.text.trim()),
        sleeve: int.parse(_sleeve.text.trim()),
        chest: int.parse(_chest.text.trim()),
        suitLength: int.parse(_suitLength.text.trim()),
      );

      // Reading data from the 'token' key. If it doesn't exist, returns null.
      final String token = prefs.getString('token');

      try {
        final response = await http.put(
            Uri.parse('https://tailoringhub.colonkoded.com/api/update/suit'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(suit.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${customer.firstName} ${customer.lastName} suit measurement updated.',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: ArgonColors.inputSuccess,
              ),
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
              'Something went wrong. Please try again!',
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
    CustomerModel customer =
        ModalRoute.of(context).settings.arguments as CustomerModel;

    return Scaffold(
      appBar: Navbar(
        title: "Suit",
        bgColor: Colors.blue,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Suit"),
      body: FutureBuilder(
          future: Provider.of<SuitProvider>(context, listen: false)
              .getSuit(customer),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            return Stack(
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
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 18.0, bottom: 36.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 8.0, bottom: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "${customer.firstName} ${customer.lastName}",
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
                                      controller: _halfBack,
                                      decoration: const InputDecoration(
                                          labelText: 'Half back'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter half back';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _shoulder,
                                      decoration: const InputDecoration(
                                          labelText: 'Shoulder'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter shoulder';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _elbow,
                                      decoration: const InputDecoration(
                                          labelText: 'Elbow'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter elbow';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _sleeve,
                                      decoration: const InputDecoration(
                                          labelText: 'Sleeve'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter sleeve';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _chest,
                                      decoration: const InputDecoration(
                                          labelText: 'Chest'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter chest';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _suitLength,
                                      decoration: const InputDecoration(
                                          labelText: 'Suit length'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter suit length';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(height: 25.0),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      child: (_isLoading)
                                          ? const SizedBox(
                                              width: double.infinity,
                                              child: SpinKitFadingCircle(
                                                color:
                                                    ArgonColors.bgColorScreen,
                                                size: 20.0,
                                              ),
                                            )
                                          : Text(
                                              (_isSuit) ? 'Update' : 'Save',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                      onPressed:
                                          (_isSuit) ? _updateSuit : _saveSuit,
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
            );
          }),
    );
  }
}
