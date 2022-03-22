import 'dart:convert';
import 'package:argon_flutter/models/shirt-model.dart';
import 'package:argon_flutter/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argon_flutter/providers/shirt-provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Shirt extends StatefulWidget {
  @override
  State<Shirt> createState() => _ShirtState();
}

class _ShirtState extends State<Shirt> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _length = TextEditingController();
  final TextEditingController _chest = TextEditingController();
  final TextEditingController _back = TextEditingController();
  final TextEditingController _sleeve = TextEditingController();
  final TextEditingController _aroundArm = TextEditingController();
  final TextEditingController _cuff = TextEditingController();
  final TextEditingController _collar = TextEditingController();
  final TextEditingController _acrossChest = TextEditingController();
  bool _isLoading = false;
  bool _isShirt = false;

  @override
  void initState() {
    ShirtModel shirt = Provider.of<ShirtProvider>(context, listen: false).shirt;
    (shirt != null)
        ? _length.text = shirt.length.toString()
        : _length.text = '';
    (shirt != null) ? _chest.text = shirt.chest.toString() : _chest.text = '';
    (shirt != null) ? _back.text = shirt.back.toString() : _back.text = '';
    (shirt != null)
        ? _sleeve.text = shirt.sleeve.toString()
        : _sleeve.text = '';
    (shirt != null)
        ? _aroundArm.text = shirt.aroundArm.toString()
        : _aroundArm.text = '';
    (shirt != null) ? _cuff.text = shirt.cuff.toString() : _cuff.text = '';
    (shirt != null)
        ? _collar.text = shirt.collar.toString()
        : _collar.text = '';
    (shirt != null)
        ? _acrossChest.text = shirt.acrossChest.toString()
        : _acrossChest.text = '';
    // Check if shirt measurement is set
    if (shirt != null) {
      setState(() {
        _isShirt = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _length.dispose();
    _chest.dispose();
    _back.dispose();
    _sleeve.dispose();
    _aroundArm.dispose();
    _cuff.dispose();
    _collar.dispose();
    _acrossChest.dispose();
    super.dispose();
  }

  // Save shirt customer measurement
  _saveShirt() async {
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
      ShirtModel shirt = ShirtModel(
        contact: customer.contact,
        length: int.parse(_length.text.trim()),
        chest: int.parse(_chest.text.trim()),
        back: int.parse(_back.text.trim()),
        sleeve: int.parse(_sleeve.text.trim()),
        aroundArm: int.parse(_aroundArm.text.trim()),
        cuff: int.parse(_cuff.text.trim()),
        collar: int.parse(_collar.text.trim()),
        acrossChest: int.parse(_acrossChest.text.trim()),
      );

      // Reading data from the 'token' key. If it doesn't exist, returns null.
      final String token = prefs.getString('token');

      try {
        final response = await http.post(
            Uri.parse('https://tailoringhub.colonkoded.com/api/create/shirt'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(shirt.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${customer.firstName} ${customer.lastName} shirt measurement saved. Add another!',
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

  _updateShirt() async {
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
      ShirtModel shirt = ShirtModel(
        contact: customer.contact,
        length: int.parse(_length.text.trim()),
        chest: int.parse(_chest.text.trim()),
        back: int.parse(_back.text.trim()),
        sleeve: int.parse(_sleeve.text.trim()),
        aroundArm: int.parse(_aroundArm.text.trim()),
        cuff: int.parse(_cuff.text.trim()),
        collar: int.parse(_collar.text.trim()),
        acrossChest: int.parse(_acrossChest.text.trim()),
      );

      // Reading data from the 'token' key. If it doesn't exist, returns null.
      final String token = prefs.getString('token');

      try {
        final response = await http.put(
            Uri.parse('https://tailoringhub.colonkoded.com/api/update/shirt'),
            headers: {
              'Authorization': 'Bearer ' + token,
              'Content-Type': 'application/json; charset=utf-8'
            },
            body: jsonEncode(shirt.toJson()));

        if (response.statusCode == 200 || response.statusCode == 201) {
          final result = jsonDecode(response.body) as Map<String, dynamic>;

          if (result['success']) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${customer.firstName} ${customer.lastName} shirt measurement updated.',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: ArgonColors.inputSuccess,
              ),
            );
          }
        } else {
          setState(() {
            _isLoading = true;
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
        } //
      } catch (ex) {
        setState(() {
          _isLoading = true;
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
        title: "Shirt(Long/Short)",
        bgColor: Colors.blue,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Shirt(Long/Short)"),
      body: FutureBuilder(
          future: Provider.of<ShirtProvider>(context, listen: false)
              .getShirt(customer),
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
                                      controller: _chest,
                                      decoration:
                                          InputDecoration(labelText: 'Chest'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter chest';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _back,
                                      decoration:
                                          InputDecoration(labelText: 'Back'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter back';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _sleeve,
                                      decoration:
                                          InputDecoration(labelText: 'Sleeve'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter sleeve';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _aroundArm,
                                      decoration: InputDecoration(
                                          labelText: 'Around Arm'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter around arm';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _cuff,
                                      decoration:
                                          InputDecoration(labelText: 'Cuff'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter cuff';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _collar,
                                      decoration: InputDecoration(
                                          labelText: 'Collar/Neck'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter collar/neck';
                                        }
                                        return null;
                                      }),
                                  TextFormField(
                                      controller: _acrossChest,
                                      decoration: InputDecoration(
                                          labelText: 'Across chest'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter across chest';
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
                                              (_isShirt) ? 'Update' : 'Save',
                                              style: TextStyle(
                                                  color:
                                                      ArgonColors.bgColorScreen,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                      onPressed: (_isShirt)
                                          ? _updateShirt
                                          : _saveShirt,
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
