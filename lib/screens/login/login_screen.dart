import 'package:flutter/material.dart';
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

  FocusNode? confirmPasswordFocusNode;
  FocusNode? emailFocusNode;
  FocusNode? passwordFocusNode;

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
                //width: _mediaQuery.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.red,
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
                ),
              ),
              Positioned(
                  bottom: _mediaQuery.height * 0.1, child: Text('button'))
            ],
          ),
        ),
      ),
    );
  }
}
