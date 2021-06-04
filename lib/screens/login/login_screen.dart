import 'package:flutter/material.dart';
import 'package:loaner/screens/reset_password/reset_password_screen.dart';
import 'package:loaner/widgets/login_form_widget.dart';
import 'package:provider/provider.dart';

import 'login_model.dart';

///the login screen widget
class LoginScreen extends StatefulWidget {
  //unique route name for the screen
  static final route = 'login_screen_route';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  TextEditingController? confirmPasswordController;
  TextEditingController? nameController;

  FocusNode? confirmPasswordFocusNode;
  FocusNode? emailFocusNode;
  FocusNode? passwordFocusNode;
  FocusNode? nameFocusNode;

  ///initialise the controllers and focus nodes
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    confirmPasswordFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    nameController = TextEditingController();
    nameFocusNode = FocusNode();
  }

  ///dispose off the controllers and focus nodes when no longer needed
  @override
  void dispose() {
    emailFocusNode!.dispose();
    passwordFocusNode!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    confirmPasswordController!.dispose();
    confirmPasswordFocusNode?.dispose();
    nameFocusNode!.dispose();
    nameController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    //listen to changes in the view model
    final viewModel = Provider.of<LoginScreenModel>(context);
    return WillPopScope(
      onWillPop: () async => await Future.value(true),
      child: Scaffold(
        body: Container(
          height: _mediaQuery.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                  child: Container(
                height: _mediaQuery.height * 0.3,
                child: Center(
                  child: Text(
                    viewModel.displayLabel,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                ),
              )),
              Positioned(
                top: _mediaQuery.height * 0.25,
                height: _mediaQuery.height * 0.65,
                child: LoginFormWidget(
                  emailController: emailController,
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                  confirmPasswordFocusNode: confirmPasswordFocusNode,
                  emailFocusNode: emailFocusNode,
                  passwordFocusNode: passwordFocusNode,
                  nameController: nameController,
                  nameFocusNode: nameFocusNode,
                ),
              ),
              Positioned(
                top: _mediaQuery.height * 0.9,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ResetPasswordScreen.route);
                  },
                  child: Text("forgot password?"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
