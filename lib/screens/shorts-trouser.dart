import 'dart:convert';
import 'package:argon_flutter/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:argon_flutter/models/shorts-trouser-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argon_flutter/providers/shorts-trouser-provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class ShortsTrouser extends StatefulWidget {
  @override
  State<ShortsTrouser> createState() => _ShortsTrouserState();
}

class _ShortsTrouserState extends State<ShortsTrouser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _waist = TextEditingController();
  final TextEditingController _length = TextEditingController();
  final TextEditingController _thighs = TextEditingController();
  final TextEditingController _bassBottom = TextEditingController();
  final TextEditingController _seat = TextEditingController();
  final TextEditingController _knee = TextEditingController();
  final TextEditingController _flapFly = TextEditingController();
  final TextEditingController _hip = TextEditingController();
  final TextEditingController _waistKnee = TextEditingController();
  bool _isLoading = false;
  bool _isShortsTrouser = false;

  @override
  void initState() {
    ShortsTrouserModel shortsTrouser =
        Provider.of<ShortsTrouserProvider>(context, listen: false)
            .shortsTrouser;
    (shortsTrouser != null)
        ? _waist.text = shortsTrouser.waist.toString()
        : _waist.text = '';
    (shortsTrouser != null)
        ? _length.text = shortsTrouser.length.toString()
        : _length.text = '';
    (shortsTrouser != null)
        ? _thighs.text = shortsTrouser.thighs.toString()
        : _thighs.text = '';
    (shortsTrouser != null)
        ? _bassBottom.text = shortsTrouser.bassBottom.toString()
        : _bassBottom.text = '';
    (shortsTrouser != null)
        ? _seat.text = shortsTrouser.seat.toString()
        : _seat.text = '';
    (shortsTrouser != null)
        ? _knee.text = shortsTrouser.knee.toString()
        : _knee.text = '';
    (shortsTrouser != null)
        ? _flapFly.text = shortsTrouser.flapFly.toString()
        : _flapFly.text = '';
    (shortsTrouser != null)
        ? _hip.text = shortsTrouser.hip.toString()
        : _hip.text = '';
    (shortsTrouser != null)
        ? _waistKnee.text = shortsTrouser.waistKnee.toString()
        : _waistKnee.text = '';
    if (shortsTrouser != null) {
      setState(() {
        _isShortsTrouser = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _waist.dispose();
    _length.dispose();
    _thighs.dispose();
    _bassBottom.dispose();
    _seat.dispose();
    _knee.dispose();
    _flapFly.dispose();
    _hip.dispose();
    _waistKnee.dispose();
    super.dispose();
  }

  // Save shorts/Trouser measurement of tailor/seamstress customer
  _saveShortsTrouser() async {
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
      ShortsTrouserModel shortsTrouser = ShortsTrouserModel(
        contact: customer.contact,
        waist: int.parse(_waist.text.trim()),
        length: int.parse(_length.text.trim()),
        thighs: int.parse(_thighs.text.trim()),
        bassBottom: int.parse(_bassBottom.text.trim()),
        seat: (_seat.text == '') ? 0 : int.parse(_seat.text.trim()),
        knee: (_knee.text == '') ? 0 : int.parse(_knee.text.trim()),
        flapFly: int.parse(_flapFly.text.trim()),
        hip: (_hip.text == '') ? 0 : int.parse(_hip.text.trim()),
        waistKnee:
            (_waistKnee.text == '') ? 0 : int.parse(_waistKnee.text.trim()),
      );

      // Reading data from the 'token' key. If it doesn't exist, returns null.
      final String token = prefs.getString('token');

      try {
        final response = await http.post(
            Uri.parse(
                'https://tailoringhub.colonkoded.com/api/create/shorts-trouser'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(shortsTrouser.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${customer.firstName} ${customer.lastName} shorts/trouser measurement saved. Add another!',
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

// Update customer shorts/trouser measurement
  _updateShortsTrouser() async {
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
      ShortsTrouserModel shortsTrouser = ShortsTrouserModel(
        contact: customer.contact,
        waist: int.parse(_waist.text.trim()),
        length: int.parse(_length.text.trim()),
        thighs: int.parse(_thighs.text.trim()),
        bassBottom: int.parse(_bassBottom.text.trim()),
        seat: (_seat.text == '') ? 0 : int.parse(_seat.text.trim()),
        knee: (_knee.text == '') ? 0 : int.parse(_knee.text.trim()),
        flapFly: int.parse(_flapFly.text.trim()),
        hip: (_hip.text == '') ? 0 : int.parse(_hip.text.trim()),
        waistKnee:
            (_waistKnee.text == '') ? 0 : int.parse(_waistKnee.text.trim()),
      );

      // Reading data from the 'token' key. If it doesn't exist, returns null.
      final String token = prefs.getString('token');

      try {
        final response = await http.put(
            Uri.parse(
                'https://tailoringhub.colonkoded.com/api/update/shorts-trouser'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(shortsTrouser.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${customer.firstName} ${customer.lastName} shorts/trouser measurement updated.',
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
        title: "Shorts/Trouser",
        bgColor: Colors.blue,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Shorts/Trouser"),
      body: FutureBuilder(
          future: Provider.of<ShortsTrouserProvider>(context, listen: false)
              .getShortsTrouser(customer),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
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
                                      controller: _waist,
                                      decoration:
                                          InputDecoration(labelText: 'Waist'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter waist';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _length,
                                      decoration:
                                          InputDecoration(labelText: 'Length'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter length';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _thighs,
                                      decoration:
                                          InputDecoration(labelText: 'Thighs'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter thighs';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _bassBottom,
                                      decoration: InputDecoration(
                                          labelText: 'Bass/Bottom'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter bass/bottom';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                    controller: _seat,
                                    decoration:
                                        InputDecoration(labelText: 'Seat'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    controller: _knee,
                                    decoration:
                                        InputDecoration(labelText: 'Knee'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                      controller: _flapFly,
                                      decoration: InputDecoration(
                                          labelText: 'Flap/Fly'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter flap/fly';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                    controller: _hip,
                                    decoration:
                                        InputDecoration(labelText: 'Hip'),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextFormField(
                                    controller: _waistKnee,
                                    decoration: InputDecoration(
                                        labelText: 'Waist knee'),
                                    keyboardType: TextInputType.number,
                                  ),
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
                                              (_isShortsTrouser)
                                                  ? 'Update'
                                                  : 'Save',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                      onPressed: (_isShortsTrouser)
                                          ? _updateShortsTrouser
                                          : _saveShortsTrouser,
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
