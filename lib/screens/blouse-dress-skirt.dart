import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:argon_flutter/models/blouse-dress-skirt-model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argon_flutter/providers/blouse-dress-skirt-provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class BlouseDressSkirt extends StatefulWidget {
  @override
  State<BlouseDressSkirt> createState() => _BlouseDressSkirtState();
}

class _BlouseDressSkirtState extends State<BlouseDressSkirt> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bust = TextEditingController();
  final TextEditingController _waist = TextEditingController();
  final TextEditingController _hip = TextEditingController();
  final TextEditingController _shoulder = TextEditingController();
  final TextEditingController _shoulderNipple = TextEditingController();
  final TextEditingController _nippleNipple = TextEditingController();
  final TextEditingController _napeWaist = TextEditingController();
  final TextEditingController _shoulderWaist = TextEditingController();
  final TextEditingController _shoulderHip = TextEditingController();
  final TextEditingController _acrossChest = TextEditingController();
  final TextEditingController _dressLength = TextEditingController();
  final TextEditingController _sleeveLength = TextEditingController();
  final TextEditingController _aroundArm = TextEditingController();
  final TextEditingController _acrossBack = TextEditingController();
  final TextEditingController _skirtLength = TextEditingController();
  bool _isLoading = false;
  bool _isBlouseDressSkirt = false;

  @override
  void initState() {
    BlouseDressSkirtModel blouseDressSkirt =
        Provider.of<BlouseDressSkirtProvider>(context, listen: false)
            .blouseDressSkirt;
    if (blouseDressSkirt != null) {
      _bust.text = blouseDressSkirt.bust.toString();
      _waist.text = blouseDressSkirt.waist.toString();
      _hip.text = blouseDressSkirt.hip.toString();
      _shoulder.text = blouseDressSkirt.shoulder.toString();
      _shoulderNipple.text = blouseDressSkirt.shoulderNipple.toString();
      _nippleNipple.text = blouseDressSkirt.nippleNipple.toString();
      _napeWaist.text = blouseDressSkirt.napeWaist.toString();
      _shoulderWaist.text = blouseDressSkirt.shoulderWaist.toString();
      _shoulderHip.text = blouseDressSkirt.shoulderHip.toString();
      _acrossChest.text = blouseDressSkirt.acrossChest.toString();
      _dressLength.text = blouseDressSkirt.dressLength.toString();
      _sleeveLength.text = blouseDressSkirt.sleeveLength.toString();
      _aroundArm.text = blouseDressSkirt.aroundArm.toString();
      _acrossBack.text = blouseDressSkirt.acrossBack.toString();
      _skirtLength.text = blouseDressSkirt.skirtLength.toString();
    } else {
      _bust.text = '';
      _waist.text = '';
      _hip.text = '';
      _shoulder.text = '';
      _shoulderNipple.text = '';
      _nippleNipple.text = '';
      _napeWaist.text = '';
      _shoulderWaist.text = '';
      _shoulderHip.text = '';
      _acrossChest.text = '';
      _dressLength.text = '';
      _sleeveLength.text = '';
      _aroundArm.text = '';
      _acrossBack.text = '';
      _skirtLength.text = '';
    }
    // Check if customer blouse/dress/skirt measurement is set
    if (blouseDressSkirt != null) {
      setState(() {
        _isBlouseDressSkirt = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _bust.dispose();
    _waist.dispose();
    _hip.dispose();
    _shoulder.dispose();
    _shoulderNipple.dispose();
    _nippleNipple.dispose();
    _napeWaist.dispose();
    _shoulderWaist.dispose();
    _shoulderHip.dispose();
    _acrossChest.dispose();
    _dressLength.dispose();
    _sleeveLength.dispose();
    _aroundArm.dispose();
    _acrossBack.dispose();
    _skirtLength.dispose();
    super.dispose();
  }

  // Save customer kabae & Slit measurement
  _saveBlouseDressSkirt() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    CustomerModel customer =
        ModalRoute.of(context).settings.arguments as CustomerModel;

    setState(() {
      _isLoading = true;
    });

    BlouseDressSkirtModel blouseDressSkirt = BlouseDressSkirtModel(
      contact: customer.contact,
      bust: (_bust.text == '') ? 0 : int.parse(_bust.text.trim()),
      waist: (_waist.text == '') ? 0 : int.parse(_waist.text.trim()),
      hip: (_hip.text == '') ? 0 : int.parse(_hip.text.trim()),
      shoulder: (_shoulder.text == '') ? 0 : int.parse(_shoulder.text.trim()),
      shoulderNipple: (_shoulderNipple.text == '')
          ? 0
          : int.parse(_shoulderNipple.text.trim()),
      nippleNipple:
          (_nippleNipple.text == '') ? 0 : int.parse(_nippleNipple.text.trim()),
      napeWaist:
          (_napeWaist.text == '') ? 0 : int.parse(_napeWaist.text.trim()),
      shoulderWaist: (_shoulderWaist.text == '')
          ? 0
          : int.parse(_shoulderWaist.text.trim()),
      shoulderHip:
          (_shoulderHip.text == '') ? 0 : int.parse(_shoulderHip.text.trim()),
      acrossChest:
          (_acrossChest.text == '') ? 0 : int.parse(_acrossChest.text.trim()),
      dressLength:
          (_dressLength.text == '') ? 0 : int.parse(_dressLength.text.trim()),
      sleeveLength:
          (_sleeveLength.text == '') ? 0 : int.parse(_sleeveLength.text.trim()),
      aroundArm:
          (_aroundArm.text == '') ? 0 : int.parse(_aroundArm.text.trim()),
      acrossBack:
          (_acrossBack.text == '') ? 0 : int.parse(_acrossBack.text.trim()),
      skirtLength:
          (_skirtLength.text == '') ? 0 : int.parse(_skirtLength.text.trim()),
    );

    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    try {
      final response = await http.post(
          Uri.parse(
              'https://tailoringhub.colonkoded.com/api/create/blouse-dress-skirt'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          },
          body: jsonEncode(blouseDressSkirt.toJson()));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;

        if (result['success']) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${customer.firstName} ${customer.lastName} blouse/dress/skirt measurement saved. Add another!'),
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
            content: const Text('Something went wrong. Please try again!'),
            backgroundColor: ArgonColors.warning,
          ),
        );
      }
    } catch (ex) {
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

  // Update customer kabae & Slit measurement
  _updateBlouseDressSkirt() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    CustomerModel customer =
        ModalRoute.of(context).settings.arguments as CustomerModel;

    setState(() {
      _isLoading = true;
    });

    BlouseDressSkirtModel blouseDressSkirt = BlouseDressSkirtModel(
      contact: customer.contact,
      bust: (_bust.text == '') ? 0 : int.parse(_bust.text.trim()),
      waist: (_waist.text == '') ? 0 : int.parse(_waist.text.trim()),
      hip: (_hip.text == '') ? 0 : int.parse(_hip.text.trim()),
      shoulder: (_shoulder.text == '') ? 0 : int.parse(_shoulder.text.trim()),
      shoulderNipple: (_shoulderNipple.text == '')
          ? 0
          : int.parse(_shoulderNipple.text.trim()),
      nippleNipple:
          (_nippleNipple.text == '') ? 0 : int.parse(_nippleNipple.text.trim()),
      napeWaist:
          (_napeWaist.text == '') ? 0 : int.parse(_napeWaist.text.trim()),
      shoulderWaist: (_shoulderWaist.text == '')
          ? 0
          : int.parse(_shoulderWaist.text.trim()),
      shoulderHip:
          (_shoulderHip.text == '') ? 0 : int.parse(_shoulderHip.text.trim()),
      acrossChest:
          (_acrossChest.text == '') ? 0 : int.parse(_acrossChest.text.trim()),
      dressLength:
          (_dressLength.text == '') ? 0 : int.parse(_dressLength.text.trim()),
      sleeveLength:
          (_sleeveLength.text == '') ? 0 : int.parse(_sleeveLength.text.trim()),
      aroundArm:
          (_aroundArm.text == '') ? 0 : int.parse(_aroundArm.text.trim()),
      acrossBack:
          (_acrossBack.text == '') ? 0 : int.parse(_acrossBack.text.trim()),
      skirtLength:
          (_skirtLength.text == '') ? 0 : int.parse(_skirtLength.text.trim()),
    );

    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    try {
      final response = await http.put(
          Uri.parse(
              'https://tailoringhub.colonkoded.com/api/update/blouse-dress-skirt'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8'
          },
          body: jsonEncode(blouseDressSkirt.toJson()));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body) as Map<String, dynamic>;

        if (result['success']) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${customer.firstName} ${customer.lastName} blouse/dress/skirt measurement updated.'),
              backgroundColor: ArgonColors.success,
            ),
          );
        }
      } else {
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
    } catch (ex) {
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

  @override
  Widget build(BuildContext context) {
    CustomerModel customer =
        ModalRoute.of(context).settings.arguments as CustomerModel;
    Provider.of<BlouseDressSkirtProvider>(context, listen: false)
        .getBlouseDressSkirt(customer);

    return Scaffold(
      appBar: Navbar(
        title: 'Blouse/Dress/Skirt',
        bgColor: Colors.blue,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Blouse/Dress/Skirt"),
      body: Stack(
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
                const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 36.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 8.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("${customer.firstName} ${customer.lastName}",
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
                              controller: _bust,
                              decoration: InputDecoration(labelText: 'Bust'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _waist,
                              decoration: InputDecoration(labelText: 'Waist'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _hip,
                              decoration: InputDecoration(labelText: 'Hip'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _shoulder,
                              decoration:
                                  InputDecoration(labelText: 'Shoulder'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _shoulderNipple,
                              decoration: InputDecoration(
                                  labelText: 'Shoulder to nipple'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _nippleNipple,
                              decoration: InputDecoration(
                                  labelText: 'Nipple to nipple'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _napeWaist,
                              decoration:
                                  InputDecoration(labelText: 'Nape to waist'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _shoulderWaist,
                              decoration: InputDecoration(
                                  labelText: 'Shoulder to waist'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _shoulderHip,
                              decoration:
                                  InputDecoration(labelText: 'Shoulder to hip'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _acrossChest,
                              decoration:
                                  InputDecoration(labelText: 'Across chest'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _dressLength,
                              decoration:
                                  InputDecoration(labelText: 'Dress length'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _sleeveLength,
                              decoration:
                                  InputDecoration(labelText: 'Sleeve length'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _aroundArm,
                              decoration:
                                  InputDecoration(labelText: 'Around arm'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _acrossBack,
                              decoration:
                                  InputDecoration(labelText: 'Across back'),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _skirtLength,
                              decoration:
                                  InputDecoration(labelText: 'Skirt length'),
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
                                          color: ArgonColors.bgColorScreen,
                                          size: 20.0,
                                        ))
                                    : Text(
                                        (_isBlouseDressSkirt)
                                            ? 'Update'
                                            : 'Save',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                onPressed: (_isBlouseDressSkirt)
                                    ? _updateBlouseDressSkirt
                                    : _saveBlouseDressSkirt,
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
