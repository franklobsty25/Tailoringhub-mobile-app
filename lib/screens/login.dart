import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final double height = window.physicalSize.height;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String _message = '';
  bool _isLoading = false;

  @override
  void initState() {
    _email.text = '';
    _password.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

// Logging in a registered tailor/seamstress
  void _login() async {
    final isValid = _formKey.currentState.validate();
    String deviceId = await PlatformDeviceId.getDeviceId;

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      final data = {
        'email': _email.text.trim(),
        'password': _password.text.trim(),
        'deviceId': deviceId,
      };

      try {
        final response = await http.post(
            Uri.parse('https://tailoringhub.colonkoded.com/api/login'),
            headers: {'Content-Type': 'application/json; charset=utf-8'},
            body: jsonEncode(data));

        if (response.statusCode == 200) {
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
            _message = 'Login credentials invalid';
          }
        } else {
          setState(() {
            _isLoading = false;
          });
          _message = 'Something went wrong. Please try again!';
        } //
      } catch (e) {
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
        appBar: AppBar(title: Text('Login')),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.63,
                                    color: Color.fromRGBO(244, 245, 247, 1),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Center(
                                              child: Text(
                                                  "Login with your credentials",
                                                  style: TextStyle(
                                                      color: ArgonColors.text,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      fontSize: 16)),
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                        controller: _email,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Email',
                                                          icon:
                                                              Icon(Icons.email),
                                                        ),
                                                        enableSuggestions: true,
                                                        keyboardType:
                                                            TextInputType
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
                                                        }),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                        controller: _password,
                                                        decoration:
                                                            const InputDecoration(
                                                          labelText: 'Password',
                                                          icon:
                                                              Icon(Icons.lock),
                                                        ),
                                                        obscureText: true,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter password';
                                                          }
                                                          return null;
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 0),
                                              child: Center(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                  ),
                                                  onPressed: _login,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 16.0,
                                                          right: 16.0,
                                                          top: 12,
                                                          bottom: 12),
                                                      child: (_isLoading)
                                                          ? SizedBox(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              child:
                                                                  const SpinKitFadingCircle(
                                                                color: Colors
                                                                    .white,
                                                                size: 20.0,
                                                              ),
                                                            )
                                                          : const Text("LOGIN",
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
                                            Center(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: ArgonColors.muted,
                                                ),
                                                child: Text(
                                                    'Don\'t have an account'),
                                                onPressed: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, '/register');
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            )),
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
