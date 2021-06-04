import 'package:flutter/material.dart';
import 'package:loaner/screens/login/login_screen.dart';
import 'package:loaner/screens/reset_password/reset_password_screen_model.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static final route = "reset_password_screen";

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController? _password, _newPassword, _confirmNewPassword;

  @override
  void initState() {
    super.initState();
    _password = TextEditingController();
    _newPassword = TextEditingController();
    _confirmNewPassword = TextEditingController();
  }

  @override
  void dispose() {
    _password!.dispose();
    _newPassword!.dispose();
    _confirmNewPassword!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizedBox = const SizedBox(
      height: 10,
    );

    final model = Provider.of<ResetPasswordScreenModel>(context);
    return WillPopScope(
      onWillPop: () async => await Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reset Password"),
        ),
        body: Container(
          margin: const EdgeInsets.all(12),
          child: ListView(
            children: [
              _textField(
                  controller: _password,
                  textLabel: model.passwordLabel,
                  onChange: (text) => model.setOldPassword = text),
              _sizedBox,
              _textField(
                  controller: _newPassword,
                  textLabel: model.newPasswordLabel,
                  onChange: (text) => model.setNewPassword = text),
              // _sizedBox,
              // _textField(
              //     controller: _confirmNewPassword,
              //     textLabel: model.confirmPasswordLabel),
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
    } catch (error) {}
  }

  ///custom TextField widget
  TextField _textField(
      {TextEditingController? controller,
      String? textLabel,
      Function(String)? onChange}) {
    return TextField(
      controller: controller!,
      onChanged: onChange,
      decoration: InputDecoration(
          labelText: textLabel!, border: const OutlineInputBorder()),
    );
  }
}
