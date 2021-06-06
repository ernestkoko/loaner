import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loaner/screens/login/login_screen.dart';
import 'package:loaner/screens/reset_password/reset_password_screen_model.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static final route = "reset_password_screen";

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController? _password, _newPassword, _emailController;

  @override
  void initState() {
    super.initState();
    _password = TextEditingController();
    _newPassword = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _password!.dispose();
    _newPassword!.dispose();
    _emailController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizedBox = const SizedBox(
      height: 10,
    );

    final model = Provider.of<ResetPasswordScreenModel>(context);
    return WillPopScope(
      onWillPop: () async {
        await Fluttertoast.showToast(msg: "Click go to login page to go back");
        return await Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reset Password"),
        ),
        body: Container(
          margin: const EdgeInsets.all(12),
          child: ListView(
            children: [
              _textField(
                  controller: _emailController,
                  textLabel: model.emailLabel,
                  onChange: (text) => model.setEmail = text),
              _sizedBox,
              _textField(
                  controller: _password,
                  textLabel: model.passwordLabel,
                  onChange: (text) => model.setOldPassword = text, obscureText: true),
              _sizedBox,
              _textField(
                  controller: _newPassword,
                  textLabel: model.newPasswordLabel,
                  onChange: (text) => model.setNewPassword = text,
                  obscureText: true),
              _sizedBox,
              ElevatedButton(
                  onPressed: () async => await _submit(model),
                  child: model.loading
                      ? CircularProgressIndicator()
                      : Text("submit")),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async => await Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.route),
                    child: Text("Back to log-in screen"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _submit(ResetPasswordScreenModel model) async {
    try {
      await model.changePassword();
      //toast a message
      await Fluttertoast.showToast(
          msg: "Password has been changed successfully",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
    } catch (error) {
      //toast the error
      await Fluttertoast.showToast(
          msg: "$error",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  ///custom TextField widget
  TextField _textField(
      {TextEditingController? controller,
      String? textLabel,
      Function(String)? onChange,
      bool obscureText = false}) {
    return TextField(
      controller: controller!,
      onChanged: onChange,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: textLabel!, border: const OutlineInputBorder()),
    );
  }
}
