import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:argon_flutter/models/customer-model.dart';
import 'package:argon_flutter/providers/suit-provider.dart';
import 'package:argon_flutter/providers/shirt-provider.dart';
import 'package:argon_flutter/providers/kaba-slit-provider.dart';
import 'package:argon_flutter/providers/shorts-trouser-provider.dart';
import 'package:argon_flutter/providers/blouse-dress-skirt-provider.dart';

//widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Choose extends StatelessWidget {
  _getCustomerMeasurement(CustomerModel customer, context) {
    Provider.of<SuitProvider>(context, listen: false).getSuit(customer);
    Provider.of<ShirtProvider>(context, listen: false).getShirt(customer);
    Provider.of<ShortsTrouserProvider>(context, listen: false)
        .getShortsTrouser(customer);
    Provider.of<BlouseDressSkirtProvider>(context, listen: false)
        .getBlouseDressSkirt(customer);
    Provider.of<KabaSlitProvider>(context, listen: false).getKabaSlit(customer);
  }

  @override
  Widget build(BuildContext context) {
    CustomerModel customer =
        ModalRoute.of(context).settings.arguments as CustomerModel;

    return Scaffold(
      appBar: Navbar(
        title: 'Add/View',
        bgColor: Colors.blue,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Add/View"),
      body: FutureBuilder(
          future: _getCustomerMeasurement(customer, context),
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
            return Container(
              padding:
                  const EdgeInsets.only(right: 18.0, left: 18.0, bottom: 36.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 8.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '${customer.firstName} ${customer.lastName} Measurement',
                            style: TextStyle(
                                color: ArgonColors.text,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ),
                    ),
                    Consumer<SuitProvider>(builder: (context, suit, child) {
                      if (suit.suit != null) {
                        return SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: const Text('View Suit'),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  '/suit',
                                  arguments: customer);
                            },
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: const Text('Add Suit'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/suit',
                                arguments: customer);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 25.0),
                    Consumer<ShirtProvider>(builder: (context, shirt, child) {
                      if (shirt.shirt != null) {
                        return SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: const Text('View Shirt [Long/Short]'),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  '/shirt',
                                  arguments: customer);
                            },
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: const Text('Add Shirt [Long/Short]'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/shirt',
                                arguments: customer);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 25.0),
                    Consumer<ShortsTrouserProvider>(
                        builder: (context, shortsTrouser, child) {
                      if (shortsTrouser.shortsTrouser != null) {
                        return SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: const Text('View Shorts/Trouser'),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  '/shorts-trouser',
                                  arguments: customer);
                            },
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: const Text('Add Shorts/Trouser'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                '/shorts-trouser',
                                arguments: customer);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 25.0),
                    Consumer<BlouseDressSkirtProvider>(
                        builder: (context, blouseDressSkirt, child) {
                      if (blouseDressSkirt.blouseDressSkirt != null) {
                        return SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: const Text('View Blouse/Dress/Skirt'),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  '/blouse-dress-skirt',
                                  arguments: customer);
                            },
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: const Text('Add Blouse/Dress/Skirt'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                '/blouse-dress-skirt',
                                arguments: customer);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 25.0),
                    Consumer<KabaSlitProvider>(
                        builder: (context, kabaSlit, child) {
                      if (kabaSlit.kabaSlit != null) {
                        return SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: const Text('View Kaba & Slit'),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                  '/kaba-slit',
                                  arguments: customer);
                            },
                          ),
                        );
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          child: const Text('Add Kaba & Slit'),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                '/kaba-slit',
                                arguments: customer);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
