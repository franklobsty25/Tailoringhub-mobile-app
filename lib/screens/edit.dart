import 'package:argon_flutter/widgets/change-password.dart';
import 'package:argon_flutter/widgets/edit-profile.dart';
import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';

//widgets
import 'package:argon_flutter/widgets/drawer.dart';

class Edit extends StatefulWidget {
  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/customer');
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/profile');
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Edit Profile'),
              Tab(text: 'Change Password'),
            ],
          ),
        ),
        backgroundColor: ArgonColors.bgColorScreen,
        drawer: ArgonDrawer(currentPage: "Edit Profile"),
        body: TabBarView(
          children: [
            EditProfile(),
            ChangePassword(),
          ],
        ),
      ),
    );
  }
}
