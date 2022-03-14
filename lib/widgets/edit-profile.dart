import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:argon_flutter/models/profile-model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argon_flutter/providers/user-profile-provider.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _about = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _job = TextEditingController();
  final TextEditingController _country = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _instagram = TextEditingController();
  final TextEditingController _twitter = TextEditingController();
  bool _isLoading = false;
  bool _isProfile = false;
  File _storedImage;

  @override
  void initState() {
    ProfileModel profile =
        Provider.of<UserProfileProvider>(context, listen: false).profile;
    if (profile != null) {
      _about.text = profile.about;
      _company.text = profile.company;
      _job.text = profile.job;
      _country.text = profile.country;
      _address.text = profile.address;
      _phone.text = (profile.phone != null) ? '0${profile.phone}' : '';
      _facebook.text = profile.facebook;
      _instagram.text = profile.instagram;
      _twitter.text = profile.twitter;
    } else {
      _about.text = '';
      _company.text = '';
      _job.text = '';
      _country.text = '';
      _address.text = '';
      _phone.text = '';
      _facebook.text = '';
      _instagram.text = '';
      _twitter.text = '';
    }
    if (profile != null) {
      setState(() {
        _isProfile = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _about.dispose();
    _company.dispose();
    _job.dispose();
    _country.dispose();
    _address.dispose();
    _phone.dispose();
    _facebook.dispose();
    _instagram.dispose();
    _twitter.dispose();
    super.dispose();
  }

  _uploadProfileImage() async {
    // Instance image picker
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile imageFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600.0,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    try {
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(imageFile.path,
            filename: path.basename(imageFile.path))
      });
      var response = await Dio().post(
        'https://tailoringhub.colonkoded.com/api/create/profile-image',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json; charset=utf-8',
        }),
      );

      if (response.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text('Upload successfully!'),
            backgroundColor: ArgonColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('Upload unsuccessful! Save profile first.'),
          backgroundColor: ArgonColors.warning,
        ),
      );
    }
  }

  // create user details if not exists
  _createUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final data = {
      'about': _about.text.trim(),
      'company': _company.text.trim(),
      'job': _job.text.trim(),
      'country': _country.text.trim(),
      'address': _address.text.trim(),
      'phone': _phone.text.trim(),
      'file': 'images/logo.png', // default image
      'facebook': _facebook.text.trim(),
      'instagram': _instagram.text.trim(),
      'twitter': _twitter.text.trim(),
    };

    var formData = FormData.fromMap(data);
    try {
      var dio = Dio();
      var response = await dio.post(
          'https://tailoringhub.colonkoded.com/api/create/details',
          data: formData,
          options: Options(headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8',
          }));

      if (response.data['success'] || response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text('Profile saved successfully!'),
            backgroundColor: ArgonColors.success,
          ),
        );
      }
    } catch (ex) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('Profile save unsuccessful!'),
          backgroundColor: ArgonColors.warning,
        ),
      );
    }
  }

  // Update if exists
  _updateUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final data = {
      'about': _about.text.trim(),
      'company': _company.text.trim(),
      'job': _job.text.trim(),
      'country': _country.text.trim(),
      'address': _address.text.trim(),
      'phone': _phone.text.trim(),
      'facebook': _facebook.text.trim(),
      'instagram': _instagram.text.trim(),
      'twitter': _twitter.text.trim(),
    };

    try {
      var dio = Dio();
      var response = await dio.put(
          'https://tailoringhub.colonkoded.com/api/update/details',
          data: data,
          options: Options(headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8',
          }));

      if (response.data['success'] || response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: ArgonColors.success,
          ),
        );
      }
    } catch (ex) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('Profile update unsuccessful!'),
          backgroundColor: ArgonColors.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<UserProfileProvider>(context, listen: false)
            .getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: AssetImage("assets/img/tailoringhub.jpg"),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: const SpinKitFadingCircle(
                      color: ArgonColors.primary,
                      size: 50.0,
                    ),
                  ),
                ),
              ],
            );
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
                padding: EdgeInsets.only(
                    top: 54.0, right: 18.0, left: 18.0, bottom: 36.0),
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
                            Row(
                              children: [
                                Container(
                                  width: 150.0,
                                  height: 100.0,
                                  child: (_storedImage != null)
                                      ? Image.file(
                                          _storedImage,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : const Text('No Image'),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    child: const Text('Upload image'),
                                    onPressed: _uploadProfileImage,
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: _about,
                              decoration: InputDecoration(
                                labelText: 'About',
                                icon: Icon(Icons.info),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                            TextFormField(
                              controller: _company,
                              decoration: InputDecoration(
                                labelText: 'Company',
                                icon: Icon(Icons.business),
                              ),
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.words,
                            ),
                            TextFormField(
                              controller: _job,
                              decoration: InputDecoration(
                                labelText: 'Job',
                                icon: Icon(Icons.business),
                              ),
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.words,
                            ),
                            TextFormField(
                              controller: _country,
                              decoration: InputDecoration(
                                labelText: 'Country',
                                icon: Icon(Icons.map),
                              ),
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.words,
                            ),
                            TextFormField(
                              controller: _address,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                icon: Icon(Icons.map_outlined),
                              ),
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.words,
                            ),
                            TextFormField(
                              controller: _phone,
                              decoration: InputDecoration(
                                labelText: 'Contact',
                                icon: Icon(Icons.contact_phone),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _facebook,
                              decoration: InputDecoration(
                                labelText: 'Facebook Link',
                                icon: FaIcon(FontAwesomeIcons.facebook),
                              ),
                            ),
                            TextFormField(
                              controller: _instagram,
                              decoration: InputDecoration(
                                labelText: 'Instagram Link',
                                icon: FaIcon(FontAwesomeIcons.instagram),
                              ),
                            ),
                            TextFormField(
                              controller: _twitter,
                              decoration: InputDecoration(
                                labelText: 'Twitter Link',
                                icon: FaIcon(FontAwesomeIcons.twitter),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: (_isLoading)
                                    ? SizedBox(
                                        width: double.infinity,
                                        child: SpinKitFadingCircle(
                                          color: ArgonColors.bgColorScreen,
                                          size: 20.0,
                                        ),
                                      )
                                    : Text(
                                        (_isProfile) ? 'Update' : 'Save',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                onPressed: (_isProfile)
                                    ? _updateUserProfile
                                    : _createUserProfile,
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
        });
  }
}
