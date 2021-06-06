import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monnify_flutter_sdk/monnify_flutter_sdk.dart';
import 'package:provider/provider.dart';

import './active_loan_model.dart';
import '../../models/repayment_mdel.dart';

class ActiveLoanScreen extends StatefulWidget {
  static final route = "active_loan_screen";

  @override
  _ActiveLoanScreenState createState() => _ActiveLoanScreenState();
}

class _ActiveLoanScreenState extends State<ActiveLoanScreen> {
  @override
  void initState() {
    super.initState();
    _initMonnify();
  }

  ///initialise payment gateway
  void _initMonnify() async {
    try {
      await MonnifyFlutterSdk.initialize(
          "MK_TEST_NBJXL9GWYU", '1735261285', ApplicationMode.TEST);
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ActiveLoanScreenModel>(context);

    double top = 0;
    return Scaffold(
        body: FutureBuilder<List<RepaymentModel>?>(
      future: model.getActiveLoan(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text("Loan"),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      childCount: 1)),
            ],
          );

        if (snapshot.hasError) {
          return Center(
            child: Text("Some errors"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text("Loan"),
                  centerTitle: true,
                  pinned: true,
                  floating: true,
                  snap: true,
                  stretch: true,
                  excludeHeaderSemantics: true,
                  expandedHeight: 100,
                  flexibleSpace: LayoutBuilder(builder: (ctx, constraint) {
                    top = constraint.biggest.height;
                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      title: AnimatedOpacity(
                        duration: Duration(microseconds: 300),
                        opacity: top < 120 ? 0.0 : 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 3),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _customText("Position"),
                                _customText("Date")
                              ]),
                        ),
                      ),
                      titlePadding: const EdgeInsets.only(top: 80),
                      centerTitle: true,
                    );
                  }),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((cont, index) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 7),
                      child: ListTile(
                        ///the method does not fire when [isLoading] is true
                        onTap: () async =>
                            await _pay(context, model, data[index].amount!),
                        leading: Text("${data[index].paymentPosition}"),
                        title: Text(
                            "\$${double.tryParse(data[index].amount!)!.roundToDouble()}"),
                        // subtitle: Text(
                        //     "${DateFormat.yMEd().format(DateTime.parse(data[index].dueDate!))}"),
                        trailing: Text(
                            "${DateFormat.yMEd().format(DateTime.parse(data[index].dueDate!))}"),
                      ),
                    ),
                  );
                }, childCount: snapshot.data!.length))
              ],
            );
          } else {
            return Center(
              child: Text("Nothing"),
            );
          }
        }
        return Center(
          child: Text("some errors occurred!"),
        );
      },
    ));
  }

  Future<void> _pay(
      BuildContext context, ActiveLoanScreenModel model, String amount) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      await model.pay(
        amount: amount,
      );

      ///show a snack bar
      scaffold.showSnackBar(
          const SnackBar(content: Text("Payment was successful")));
    } catch (error) {
      //show a snack bar of the error
      scaffold.showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Widget _customText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 12),
    );
  }

}
