import 'package:argon_flutter/providers/customer-provider.dart';
import 'package:argon_flutter/providers/shorts-trouser-provider.dart';
import 'package:argon_flutter/providers/suit-provider.dart';
import 'package:argon_flutter/providers/shirt-provider.dart';
import 'package:argon_flutter/providers/blouse-dress-skirt-provider.dart';
import 'package:argon_flutter/providers/kaba-slit-provider.dart';
import 'package:argon_flutter/providers/user-profile-provider.dart';
import 'package:argon_flutter/screens/blouse-dress-skirt.dart';
import 'package:argon_flutter/screens/kaba-slit.dart';
import 'package:argon_flutter/screens/choose.dart';
import 'package:argon_flutter/screens/shirt.dart';
import 'package:argon_flutter/screens/shorts-trouser.dart';
import 'package:argon_flutter/screens/subscription.dart';
import 'package:argon_flutter/screens/suggestion.dart';
import 'package:argon_flutter/screens/suit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// screens
import 'package:argon_flutter/screens/home.dart';
import 'package:argon_flutter/screens/profile.dart';
import 'package:argon_flutter/screens/register.dart';
import 'package:argon_flutter/screens/login.dart';
import 'package:argon_flutter/screens/edit.dart';
import 'package:argon_flutter/screens/customer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CustomerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SuitProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShirtProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShortsTrouserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BlouseDressSkirtProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KabaSlitProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProfileProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Tailoringhub',
        theme: ThemeData(fontFamily: 'OpenSans'),
        initialRoute: "/login",
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          "/home": (BuildContext context) => new Home(),
          "/profile": (BuildContext context) => new Profile(),
          "/login": (BuildContext context) => new Login(),
          "/register": (BuildContext context) => new Register(),
          "/edit": (BuildContext context) => new Edit(),
          "/customer": (BuildContext context) => new Customer(),
          "/choose": (BuildContext context) => new Choose(),
          "/suit": (BuildContext context) => new Suit(),
          "/shirt": (BuildContext context) => new Shirt(),
          "/shorts-trouser": (BuildContext context) => new ShortsTrouser(),
          "/blouse-dress-skirt": (BuildContext context) =>
              new BlouseDressSkirt(),
          "/kaba-slit": (BuildContext context) => new KabaSlit(),
          "/subscription": (BuildContext context) => new Subscription(),
          "/suggestion": (BuildContext context) => new Suggestion(true, ''),
        },
      ),
    );
  }
}
