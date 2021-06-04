import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loaner/screens/login/login_model.dart';
import 'package:loaner/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';

class LoginFormWidget extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  final FocusNode? confirmPasswordFocusNode;
  final FocusNode? emailFocusNode;
  final FocusNode? passwordFocusNode;
  final TextEditingController? nameController;
  final FocusNode? nameFocusNode;

  const LoginFormWidget(
      {Key? key,
      this.emailController,
      this.passwordController,
      this.confirmPasswordController,
      this.confirmPasswordFocusNode,
      this.emailFocusNode,
      this.passwordFocusNode,
      this.nameFocusNode,
      this.nameController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginScreenModel>(
        builder: (cxt, loginScreenModel, child) => SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      onChanged: loginScreenModel.updateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: loginScreenModel.emailLabel,
                          errorText: loginScreenModel.emailErrorMessage,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      onChanged: loginScreenModel.updatePassword,
                      decoration: InputDecoration(
                          labelText: loginScreenModel.passwordLabel,
                          errorText: loginScreenModel.passwordErrorMessage,
                          border: OutlineInputBorder()),
                    ),
                    //check if show confirm password is true
                    if (loginScreenModel.showConfirmPassword)
                      Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: confirmPasswordController,
                            focusNode: confirmPasswordFocusNode,
                            onChanged: loginScreenModel.updateConfirmPassword,
                            decoration: InputDecoration(
                                labelText:
                                    loginScreenModel.confirmPasswordLabel,
                                errorText: loginScreenModel
                                    .confirmPasswordErrorMessage,
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: nameController,
                            focusNode: nameFocusNode,
                            onChanged: loginScreenModel.updateName,
                            decoration: InputDecoration(
                                labelText: loginScreenModel.nameLabel,
                                errorText: loginScreenModel.nameErrorMessage,
                                border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: loginScreenModel.isLoading
                            ? null
                            : () async =>
                                await _signin(loginScreenModel, context),
                        child: loginScreenModel.isLoading
                            ? CircularProgressIndicator()
                            : Text(loginScreenModel.submitButtonLabel)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(loginScreenModel.haveAccountOrNotLabel),
                        TextButton(
                            onPressed: loginScreenModel.isLoading
                                ? null
                                : loginScreenModel.toggleFormState,
                            child: Text(loginScreenModel.toggleButtonLabel))
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  ///Sign in or register a new user
  Future _signin(LoginScreenModel model, BuildContext context) async {
    //hide the soft keyboard
    FocusScope.of(context).unfocus();
    try {
      await model.registerOrLoginUser();

      ///catch any firebase authentication error
    } on FirebaseAuthException catch (error) {
      await _popUpDialog(context, title: error.code, content: error.message);

      ///catch any platform exception
    } on PlatformException catch (error) {
      await _popUpDialog(context, title: error.code, content: error.message);

      ///catch any other error
    } catch (error) {
      await _popUpDialog(context,
          title: 'Something went wrong', content: error.toString());
    }
  }
}

Future _popUpDialog(BuildContext context,
    {String? title, String? content}) async {
  await CustomAlertDialog(
    title: title!,
    content: content!,
  ).show(context);
}
