import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _currentPassword.text = '';
    _newPassword.text = '';
    _confirmPassword.text = '';
    super.initState();
  }

  @override
  void dispose() {
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  _changePassword() async {
    final isValid = _formKey.currentState.validate();
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      final data = {
        'currentPassword': _currentPassword.text.trim(),
        'newPassword': _newPassword.text.trim(),
      };

      // Save a String value to 'token' key.
      final String token = prefs.getString('token');

      try {
        final response = await http.put(
            Uri.parse(
                'https://tailoringhub.colonkoded.com/api/change-password'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(data));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message']),
                backgroundColor: ArgonColors.success,
              ),
            );
          } else {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message']),
                backgroundColor: ArgonColors.warning,
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
                  'Current password don\'t match. Please try again!'),
              backgroundColor: ArgonColors.warning,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text('Something went wrong. Please try again!'),
            backgroundColor: ArgonColors.warning,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/img/tailoringhub.jpg"),
                fit: BoxFit.fitWidth),
          ),
        ),
        Container(
          padding:
              EdgeInsets.only(top: 74.0, right: 18.0, left: 18.0, bottom: 36.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _currentPassword,
                          decoration: InputDecoration(
                            labelText: 'Current Password',
                            icon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter current password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _newPassword,
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            icon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _confirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm New Password',
                            icon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter confirm new password';
                            }
                            if (value != _newPassword.text) {
                              return 'Password don\'t match';
                            }
                            return null;
                          }),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: (_isLoading)
                              ? const SizedBox(
                                  width: double.infinity,
                                  child: SpinKitFadingCircle(
                                    color: ArgonColors.bgColorScreen,
                                    size: 20.0,
                                  ),
                                )
                              : Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                          onPressed: _changePassword,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
