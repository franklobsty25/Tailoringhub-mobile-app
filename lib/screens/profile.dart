import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:argon_flutter/providers/user-profile-provider.dart';

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Profile extends StatelessWidget {
  _launchFacebook(context, url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchInstagram(context, url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTwitter(context, url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Navbar(
        title: "Profile",
        transparent: true,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Profile"),
      body: FutureBuilder(
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
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage("assets/img/tailoringhub.jpg"),
                            fit: BoxFit.fitWidth))),
                SafeArea(
                  child: ListView(children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 74.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  elevation: .0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 85.0, bottom: 20.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Consumer<UserProfileProvider>(
                                                  builder:
                                                      (context, profile, _) {
                                                if (profile.profile != null) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (profile.profile
                                                              .facebook !=
                                                          null)
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ArgonColors
                                                                .info,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.3),
                                                                spreadRadius: 1,
                                                                blurRadius: 7,
                                                                offset: Offset(
                                                                    0,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: IconButton(
                                                            icon: FaIcon(
                                                                FontAwesomeIcons
                                                                    .facebook),
                                                            color: ArgonColors
                                                                .facebook,
                                                            onPressed: () {
                                                              _launchFacebook(
                                                                  context,
                                                                  profile
                                                                      .profile
                                                                      .facebook);
                                                            },
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        width: 30.0,
                                                      ),
                                                      if (profile.profile
                                                              .instagram !=
                                                          null)
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ArgonColors
                                                                .info,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.3),
                                                                spreadRadius: 1,
                                                                blurRadius: 7,
                                                                offset: Offset(
                                                                    0,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: IconButton(
                                                            icon: FaIcon(
                                                                FontAwesomeIcons
                                                                    .instagram),
                                                            color: ArgonColors
                                                                .label,
                                                            onPressed: () {
                                                              _launchInstagram(
                                                                  context,
                                                                  profile
                                                                      .profile
                                                                      .instagram);
                                                            },
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        width: 30.0,
                                                      ),
                                                      if (profile.profile
                                                              .twitter !=
                                                          null)
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ArgonColors
                                                                .info,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3.0),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.3),
                                                                spreadRadius: 1,
                                                                blurRadius: 7,
                                                                offset: Offset(
                                                                    0,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: IconButton(
                                                            icon: FaIcon(
                                                                FontAwesomeIcons
                                                                    .twitter),
                                                            color: ArgonColors
                                                                .twitter,
                                                            onPressed: () {
                                                              _launchTwitter(
                                                                  context,
                                                                  profile
                                                                      .profile
                                                                      .twitter);
                                                            },
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                }
                                                return const Text('');
                                              }),
                                              SizedBox(height: 40.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Consumer<UserProfileProvider>(
                                                      builder:
                                                          (context, total, _) {
                                                    if (total.totalCustomers ==
                                                            0 ||
                                                        total.totalCustomers ==
                                                            null) {
                                                      return const Text(
                                                          'No Customer added yet');
                                                    }
                                                    return Column(
                                                      children: [
                                                        Text(
                                                            total.totalCustomers
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        82,
                                                                        95,
                                                                        127,
                                                                        1),
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text("Customers",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        50,
                                                                        50,
                                                                        93,
                                                                        1),
                                                                fontSize: 12.0))
                                                      ],
                                                    );
                                                  })
                                                ],
                                              ),
                                              SizedBox(height: 40.0),
                                              Consumer<UserProfileProvider>(
                                                  builder:
                                                      (context, user, child) {
                                                return Align(
                                                  child: Text(
                                                      "${user.user.firstName} ${user.user.lastName}",
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              50, 50, 93, 1),
                                                          fontSize: 28.0)),
                                                );
                                              }),
                                              SizedBox(height: 10.0),
                                              Consumer<UserProfileProvider>(
                                                  builder: (context, profile,
                                                      child) {
                                                if (profile.profile != null) {
                                                  if (profile.profile.address !=
                                                          null &&
                                                      profile.profile.country !=
                                                          null) {
                                                    return Align(
                                                      child: Text(
                                                          "${profile.profile.address}, ${profile.profile.country}",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      50,
                                                                      50,
                                                                      93,
                                                                      1),
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200)),
                                                    );
                                                  }
                                                }
                                                return const Text('');
                                              }),
                                              Divider(
                                                height: 40.0,
                                                thickness: 1.5,
                                                indent: 32.0,
                                                endIndent: 32.0,
                                              ),
                                              Consumer<UserProfileProvider>(
                                                  builder: (context, profile,
                                                      child) {
                                                if (profile.profile != null) {
                                                  if (profile.profile.about !=
                                                      null) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 32.0,
                                                              right: 32.0),
                                                      child: Align(
                                                        child: Text(
                                                            "${profile.profile.about}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        82,
                                                                        95,
                                                                        127,
                                                                        1),
                                                                fontSize: 17.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200)),
                                                      ),
                                                    );
                                                  }
                                                }
                                                return const Text('');
                                              }),
                                              SizedBox(height: 25.0),
                                              Consumer<UserProfileProvider>(
                                                  builder:
                                                      (context, user, child) {
                                                if (user.user.email != null) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 25.0,
                                                            left: 25.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Email",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16.0,
                                                              color: ArgonColors
                                                                  .text),
                                                        ),
                                                        Text(
                                                          "${user.user.email}",
                                                          style: TextStyle(
                                                              color: ArgonColors
                                                                  .primary,
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                                return const Text('');
                                              }),
                                              SizedBox(height: 25.0),
                                              Consumer<UserProfileProvider>(
                                                  builder: (context, profile,
                                                      child) {
                                                if (profile.profile != null) {
                                                  if (profile.profile.phone !=
                                                      null) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 25.0,
                                                              left: 25.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Contact",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0,
                                                                color:
                                                                    ArgonColors
                                                                        .text),
                                                          ),
                                                          Text(
                                                            "0${profile.profile.phone}",
                                                            style: TextStyle(
                                                                color:
                                                                    ArgonColors
                                                                        .primary,
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
                                                return const Text('');
                                              }),
                                              SizedBox(height: 25.0),
                                              Consumer<UserProfileProvider>(
                                                  builder: (context, profile,
                                                      child) {
                                                if (profile.profile != null) {
                                                  if (profile.profile.company !=
                                                      null) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 25.0,
                                                              left: 25.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Company",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0,
                                                                color:
                                                                    ArgonColors
                                                                        .text),
                                                          ),
                                                          Text(
                                                            "${profile.profile.company}",
                                                            style: TextStyle(
                                                                color:
                                                                    ArgonColors
                                                                        .primary,
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
                                                return const Text('');
                                              }),
                                              SizedBox(height: 25.0),
                                              Consumer<UserProfileProvider>(
                                                  builder: (context, profile,
                                                      child) {
                                                if (profile.profile != null) {
                                                  if (profile.profile.job !=
                                                      null) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 25.0,
                                                              left: 25.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Job",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0,
                                                                color:
                                                                    ArgonColors
                                                                        .text),
                                                          ),
                                                          Text(
                                                            "${profile.profile.job}",
                                                            style: TextStyle(
                                                                color:
                                                                    ArgonColors
                                                                        .primary,
                                                                fontSize: 13.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                }
                                                return const Text('');
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Consumer<UserProfileProvider>(
                                builder: (context, profile, child) {
                              if (profile.profile != null) {
                                if (profile.profile.image != null) {
                                  return FractionalTranslation(
                                      translation: Offset(0.0, -0.5),
                                      child: Align(
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "https://tailoringhub.colonkoded.com/${profile.profile.image}"),
                                          radius: 65.0,
                                          // maxRadius: 200.0,
                                        ),
                                        alignment: FractionalOffset(0.5, 0.0),
                                      ));
                                }
                              }
                              return FractionalTranslation(
                                  translation: Offset(0.0, -0.5),
                                  child: Align(
                                    child: CircleAvatar(
                                      backgroundColor:
                                          ArgonColors.bgColorScreen,
                                      backgroundImage: AssetImage(
                                          "assets/img/tailoringhub.jpg"),
                                      radius: 65.0,
                                      // maxRadius: 200.0,
                                    ),
                                    alignment: FractionalOffset(0.5, 0.0),
                                  ));
                            })
                          ]),
                        ],
                      ),
                    ),
                  ]),
                )
              ],
            );
          }),
    );
  }
}
