import 'package:argon_flutter/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:argon_flutter/providers/customer-provider.dart';

// Widgets
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:argon_flutter/widgets/drawer.dart';

class Home extends StatelessWidget {
  _searchCustomer(context, contact) async {
    try {
      await Provider.of<CustomerProvider>(context, listen: false)
          .searchCustomer(contact);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Contact not found',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
                            return Dismissible(
                              key: ValueKey(_getToken()),
                              background: Container(
                                color: Colors.red,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 20.0),
                                margin: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 15,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text(
                                        'Do you want to delete ${customer.customers[index].firstName} ${customer.customers[index].lastName}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) async {
                                try {
                                  await Provider.of<CustomerProvider>(context,
                                          listen: false)
                                      .deleteCustomer(
                                          customer.customers[index]);
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Deleting failed!',
                                          textAlign: TextAlign.center),
                                    ),
                                  );
                                }
                              },
                              child: Card(
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
                                    icon: Icon(Icons.message),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/subscription',
                                              arguments: customer
                                                  .customers[index].contact);
                                    },
                                  ),
                                ),
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
