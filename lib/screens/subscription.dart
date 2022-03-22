import 'dart:convert';
import 'package:argon_flutter/screens/loading.dart';
import 'package:argon_flutter/screens/suggestion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argon_flutter/providers/user-profile-provider.dart';

// Widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Subscription extends StatefulWidget {
  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  var publicKey = 'PAYSTACK_PUBLIC_KEY';
  final plugin = PaystackPlugin();

  @override
  void initState() {
    plugin.initialize(publicKey: publicKey);
    super.initState();
  }

  _subscription(context) async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String email = prefs.getString('email');

    try {
      final response = await http.post(
        Uri.parse(
            'https://tailoringhub.colonkoded.com/api/subscription/payment'),
        headers: {
          'Authorization': 'Bearer ' + token,
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({'amount': 5}),
      );

      final result = jsonDecode(response.body) as Map<String, dynamic>;

      Charge charge = new Charge();
      charge.amount = 5 * 100;
      charge.email = email;
      charge.accessCode = result['data']['access_code'];
      charge.currency = 'GHS';

      CheckoutResponse checkoutResponse = await plugin.checkout(context,
          charge: charge, method: CheckoutMethod.selectable);

      final verifyResponse = await http.get(
          Uri.parse(
              'https://tailoringhub.colonkoded.com/api/verify/payment/${checkoutResponse.reference}'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json; charset=utf-8',
          });

      final res = jsonDecode(verifyResponse.body) as Map<String, dynamic>;

      if (res['status']) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Something went wrong. Please try again!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: Navbar(
        title: '',
        bgColor: Colors.blue,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Subscription"),
      body: FutureBuilder(
          future: Provider.of<UserProfileProvider>(context, listen: false)
              .getUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            return Consumer<UserProfileProvider>(
                builder: (context, user, child) {
              if (user.user.reference != '' || user.user.reference.isNotEmpty) {
                return Suggestion(false, contact.toString());
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                          'Subscribe GHS 5.00 monthly to keep sending messages to customers for pick up',
                          style: TextStyle(
                              color: ArgonColors.info,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center),
                      SizedBox(height: 25.0),
                      TextButton(
                        child: Text(
                          'Subscribe',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w300),
                        ),
                        onPressed: () => _subscription(context),
                      ),
                    ],
                  ),
                ),
              );
            });
          }),
    );
  }
}
