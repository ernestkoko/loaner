import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loaner/models/repayment_mdel.dart';
import 'package:loaner/screens/active_loan/active_loan_model.dart';
import 'package:provider/provider.dart';

class ActiveLoanScreen extends StatelessWidget {
  static final route = "active_loan_screen";

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
                    print("Constraint: $constraint");
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
                        onTap: () {
                          ///navigate to the to pay
                        },
                        leading: Text("${data[index].paymentPosition}"),
                        title: Text("\$${data[index].amount}"),
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

  Widget _customText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 12),
    );
  }
}
