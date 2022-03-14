import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:argon_flutter/providers/customer-provider.dart';

// Widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Home extends StatelessWidget {
  _searchCustomer(context, contact) {
    Provider.of<CustomerProvider>(context, listen: false)
        .searchCustomer(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Home",
        searchBar: true,
        bgColor: Colors.blue,
        searchOnSubmitted: _searchCustomer,
      ),
      backgroundColor: ArgonColors.bgColorScreen,
      drawer: ArgonDrawer(currentPage: "Home"),
      body: FutureBuilder(
          future: Provider.of<CustomerProvider>(context, listen: false)
              .getCustomers(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
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
                  padding: const EdgeInsets.only(
                      right: 10.0, left: 10.0, bottom: 30.0),
                  child: RefreshIndicator(
                    onRefresh: () =>
                        Provider.of<CustomerProvider>(context, listen: false)
                            .getCustomers(),
                    color: ArgonColors.primary,
                    child: Consumer<CustomerProvider>(
                        builder: (context, customer, child) {
                      if (customer.customers.isEmpty) {
                        return Center(
                            child: Text('No customer added yet',
                                style: TextStyle(
                                  color: ArgonColors.primary,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )));
                      }
                      return ListView.builder(
                          itemCount: customer.customers.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: ArgonColors.bgColorScreen,
                                  backgroundImage:
                                      AssetImage("assets/img/logo.png"),
                                ),
                                title: Text(
                                    '${customer.customers[index].firstName} ${customer.customers[index].lastName}'),
                                subtitle: Text(
                                    '0${customer.customers[index].contact}'),
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/choose',
                                      arguments: customer.customers[index]);
                                },
                                trailing: IconButton(
                                    icon: Icon(Icons.delete,
                                        color: ArgonColors.warning),
                                    onPressed: () {
                                      Provider.of<CustomerProvider>(context,
                                              listen: false)
                                          .deleteCustomer(
                                              customer.customers[index]);
                                    }),
                              ),
                            );
                          });
                    }),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
