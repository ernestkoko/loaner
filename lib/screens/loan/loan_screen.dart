import 'package:flutter/material.dart';
import 'package:loaner/screens/home/home_screen.dart';
import 'package:loaner/screens/loan/loan_model.dart';
import 'package:provider/provider.dart';

///a screen for customer to get loan
class LoanScreen extends StatefulWidget {
  static final route = "loan_screen_route";

  @override
  _LoanScreenState createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  // TextEditingController? _amountController;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   //initialise
  //   _amountController = TextEditingController();
  // }
  //
  // @override
  // void dispose() {
  //   //dispose if not null
  //   _amountController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoanScreenModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(model.appBarTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              TextField(

                onChanged: (value) => model.setAmount = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    errorText: model.amountErrorMessage,
                    enabled: !model.isLoading,
                    errorMaxLines: 2,
                    labelText: model.amountLabel,
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                onChanged: (value) {
                  ///set the selected value
                  model.selectedMonth = value!;
                },
                items: model.isLoading
                    ? [
                        DropdownMenuItem(
                          child: Text("${model.numberOfMonths!} "),
                          value: model.numberOfMonths,
                        )
                      ]
                    : model.dropDownLabels
                        .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                decoration: InputDecoration(
                    enabled: !model.isLoading,
                    labelText: model.numberOfMonthsLabel,
                    border: OutlineInputBorder()),
              ),
              ElevatedButton(
                  onPressed: model.isLoading
                      ? null
                      : () async => await _submit(context, model),
                  child: model.isLoading
                      ? CircularProgressIndicator()
                      : Text(model.takeButtonLabel))
            ],
          ),
        ));
  }

  Future<void> _submit(BuildContext context, LoanScreenModel model) async {
    try {
      ///hide the soft key board
      FocusScope.of(context).unfocus();
      //submit
      await model.borrow();
      final scaffold = ScaffoldMessenger.of(context);
      //clear the snack bar if any
      scaffold.clearSnackBars();
      scaffold.showSnackBar(SnackBar(
        content: Text('Loan was successful!'),
      ));

      ///pop this page
      await Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    } on FormatException catch (error) {
      ///
      final scaffold = ScaffoldMessenger.of(context);
      //clear the snack bar if any
      scaffold.clearSnackBars();
      scaffold.showSnackBar(SnackBar(
        content: Text(error.message),
      ));
    } catch (error) {
      final scaffold = ScaffoldMessenger.of(context);
      //clear the snack bar if any
      scaffold.clearSnackBars();
      scaffold.showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
  }
}
