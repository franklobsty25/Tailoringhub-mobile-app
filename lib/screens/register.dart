import 'dart:ui';
import 'dart:convert';
import 'package:argon_flutter/models/register-model.dart';
import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final double height = window.physicalSize.height;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  @override
  void initState() {
    _firstName.text = '';
    _lastName.text = '';
    _email.text = '';
    _password.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

// Registering tailor/seamstress to database
  void _registeration() async {
    final isValid = _formKey.currentState.validate();
    String deviceId = await PlatformDeviceId.getDeviceId;

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      RegisterModel registerData = new RegisterModel(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        password: _password.text.trim(),
        deviceId: deviceId,
      );

      try {
        final response = await http.post(
            Uri.parse('https://tailoringhub.colonkoded.com/api/register'),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonEncode(registerData.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });
            // Obtain shared preferences.
            final prefs = await SharedPreferences.getInstance();
            // Save a String value to 'token' key.
            await prefs.setString('token', result['token']);

            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            setState(() {
              _isLoading = false;
            });
            _message = 'Registration unsuccessful. Check your email';
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          _message = 'Something went wrong. Please try again!';
        } //
      } catch (ex) {
        setState(() {
          _isLoading = false;
        });
        _message = 'Something went wrong. Please try again!';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign up'),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            SafeArea(
              child: ListView(children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 24.0, right: 24.0, bottom: 32),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/img/logo.png"),
                        ),
                        Card(
                          elevation: 5,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                color: Color.fromRGBO(244, 245, 247, 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 24.0, bottom: 24.0),
                                            child: Center(
                                              child: Text(
                                                "Sign up with your credentials",
                                                style: TextStyle(
                                                    color: ArgonColors.text,
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    _message,
                                                    style: TextStyle(
                                                        color: ArgonColors
                                                            .warning),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: _firstName,
                                                    decoration: InputDecoration(
                                                      labelText: 'First Name',
                                                      icon: Icon(Icons.person),
                                                    ),
                                                    autocorrect: true,
                                                    enableSuggestions: true,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter first name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: _lastName,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Last Name',
                                                      icon: Icon(Icons.person),
                                                    ),
                                                    autocorrect: true,
                                                    enableSuggestions: true,
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .words,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter last name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: _email,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Email',
                                                      icon: Icon(Icons.email),
                                                    ),
                                                    enableSuggestions: true,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter email';
                                                      }
                                                      if (!value
                                                          .contains('@')) {
                                                        return 'Invalid email address';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: _password,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Password',
                                                      icon: Icon(Icons.lock),
                                                    ),
                                                    obscureText: true,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter password';
                                                      }
                                                      if (value.length < 8) {
                                                        return 'Please should be 8 atleast character long';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24.0),
                                                  child: RichText(
                                                      text: TextSpan(
                                                          text:
                                                              "password strength: ",
                                                          style: TextStyle(
                                                              color: ArgonColors
                                                                  .muted),
                                                          children: [
                                                        TextSpan(
                                                            text: "strong",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: ArgonColors
                                                                    .success))
                                                      ])),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Center(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                ),
                                                onPressed: _registeration,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0,
                                                            right: 16.0,
                                                            top: 12,
                                                            bottom: 12),
                                                    child: (_isLoading)
                                                        ? const SizedBox(
                                                            width: 20.0,
                                                            height: 20.0,
                                                            child:
                                                                const SpinKitFadingCircle(
                                                              color:
                                                                  Colors.white,
                                                              size: 20.0,
                                                            ),
                                                          )
                                                        : const Text("REGISTER",
                                                            style: TextStyle(
                                                                color:
                                                                    ArgonColors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    16.0))),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0.0),
                                            child: Center(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: ArgonColors.muted,
                                                ),
                                                child: Text(
                                                    'Already have an account'),
                                                onPressed: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, '/login');
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}
