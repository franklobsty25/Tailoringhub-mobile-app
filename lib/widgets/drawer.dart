import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:argon_flutter/widgets/drawer-tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ArgonDrawer extends StatelessWidget {
  final String currentPage;

  ArgonDrawer({this.currentPage});

  _launchURL() async {
    const url = 'https://colonkoded.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

// Logging out signed in tailor/seamstress
  _logout(context) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    // Reading data from the 'token' key. If it doesn't exist, returns null.
    final String token = prefs.getString('token');

    final response = await http.get(
        Uri.parse('https://tailoringhub.colonkoded.com/api/logout'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json; charset=utf-8'
        });
    final result = jsonDecode(response.body) as Map<String, dynamic>;

    if (result['success']) {
      Navigator.of(context).pushReplacementNamed('/login');
      await prefs.remove('token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: ArgonColors.white,
      child: Column(children: [
        Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Image.asset("assets/img/logo.png", fit: BoxFit.cover),
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16),
            children: [
              DrawerTile(
                  icon: Icons.home,
                  onTap: () {
                    if (currentPage != "Home")
                      Navigator.pushReplacementNamed(context, '/home');
                  },
                  iconColor: ArgonColors.primary,
                  title: "Home",
                  isSelected: currentPage == "Home" ? true : false),
              DrawerTile(
                  icon: Icons.edit,
                  onTap: () {
                    if (currentPage != "Edit Profile")
                      Navigator.pushReplacementNamed(context, '/edit');
                  },
                  iconColor: ArgonColors.warning,
                  title: "Edit Profile",
                  isSelected: currentPage == "Edit Profile" ? true : false),
              DrawerTile(
                  icon: Icons.add,
                  onTap: () {
                    if (currentPage != "Measurement")
                      Navigator.pushReplacementNamed(context, '/customer');
                  },
                  iconColor: ArgonColors.info,
                  title: "Measurement",
                  isSelected: currentPage == "Measurement" ? true : false),
              // DrawerTile(
              //     icon: Icons.add,
              //     onTap: () {
              //       if (currentPage != "Selection")
              //         Navigator.pushReplacementNamed(context, '/choose');
              //     },
              //     iconColor: ArgonColors.info,
              //     title: "Selection",
              //     isSelected: currentPage == "Selection" ? true : false),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 4, thickness: 0, color: ArgonColors.muted),
                  DrawerTile(
                      icon: Icons.email_outlined,
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/suggestion');
                      },
                      title: "Suggestions"),
                  DrawerTile(
                      icon: Icons.open_in_browser,
                      onTap: _launchURL,
                      iconColor: ArgonColors.muted,
                      title: "Know more",
                      isSelected:
                          currentPage == "Getting started" ? true : false),
                  Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: ArgonColors.warning,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: ArgonColors.warning,
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(color: ArgonColors.warning),
                        ),
                        onPressed: () {
                          _logout(context);
                        },
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ]),
    ));
  }
}
