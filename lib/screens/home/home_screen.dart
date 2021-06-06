import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loaner/screens/active_loan/active_loan_screen.dart';
import 'package:loaner/screens/loan/loan_screen.dart';
import 'package:loaner/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';

import './home_model.dart';
import '../../models/stock_model.dart';
import '../../widgets/custom_card_view.dart';

///Home page widget
class HomeScreen extends StatelessWidget {
  static final route = 'home_screen_route';

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeScreenModel>(context, listen: false);
    final nav = Navigator.of(context);
    return WillPopScope(
      ///stop the user from leaving this page by pressing the back button
      onWillPop: () async => await Future.value(false),
      child: Scaffold(
        ///the app bar of the page
        appBar: AppBar(
          title: Text(model.titleLabel),
          actions: [
            FutureBuilder<bool>(
                future: model.getActiveLoan(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  }
                  if (snapshot.hasError) {
                    print("Error: ${snapshot.error}");
                    return Text("Error");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      final data = snapshot.data as bool;
                      if (data == true) {
                        return IconButton(
                            onPressed: () async =>
                                await nav.pushNamed(ActiveLoanScreen.route),
                            icon: Text("Loan"));
                      } else {
                        return IconButton(
                            //navigate to loan screen when pressed
                            onPressed: () async => await Navigator.of(context)
                                .pushNamed(LoanScreen.route),
                            icon: Icon(Icons.account_balance_wallet_outlined));
                      }
                    }
                  }
                  return Text("Error");
                })
          ],
        ),

        ///the body of the page
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(8),
            child: FutureBuilder<List<StockModel>>(
              future: model.getStocks(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(model.snapShotErrorLabel),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                              " ${model.portFolioLabel + model.portFolioValue}"),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int i) =>
                                CustomCardView(
                              symbol: snapshot.data![i].symbol,
                              pricePerShare:
                                  "${model.pricePerShareLabel + snapshot.data![i].pricePerShare!}",
                              quantity:
                                  "${model.quantityLabel + snapshot.data![i].totalQuantity!}",
                              equityValue:
                                  "${model.equityValueLabel + snapshot.data![i].equityValue!}",
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(model.dataIsEmptyLabel),
                    );
                  }
                }
                return Center(
                  child: Text(model.snapShotErrorLabel),
                );
              },
            ),
          ),
        ),

        ///the side navigation drawer
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  UserAccountsDrawerHeader(
                    accountEmail: Text(model.userEmail!),
                    accountName: Text(" ${model.displayName??"Your name"}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.home_rounded),
                    title: Text(model.homeLabel),
                    onTap: () {
                      ///close the drawer
                      Navigator.of(context).pop();
                    },
                  ),

                  ///list tile for navigating to active loan screen
                  ListTile(
                    leading: Icon(Icons.pending_actions_rounded),
                    title: Text(model.activeLoanLabel),
                    onTap: () async {
                      //close the drawer
                      nav.pop();
                      //navigate to the settings screen
                      await nav.pushNamed(ActiveLoanScreen.route);
                    },
                  ),

                  ///a list tile for the settings
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(model.settingsLabel),
                    onTap: () async {
                      final nav = Navigator.of(context);
                      //close the drawer
                      nav.pop();
                      //navigate to the settings screen
                      await nav.pushNamed(SettingsScreen.route);
                    },
                  )
                ],
              ),

              ///List tile for the log out
              ListTile(
                onTap: () async => await _logout(model),
                leading: Icon(
                  Icons.logout,
                  color: Theme.of(context).errorColor,
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    model.logoutLabel,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(HomeScreenModel model) async {
    try {
      await model.logout();
    } catch (error) {
      await Fluttertoast.showToast(msg: "An error occurred");
    }
  }
}
