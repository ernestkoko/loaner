import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../enums/form_state.dart';
import '../../models/firebase_user_model.dart';
import '../../repositories/firebase_repository.dart';

/// a class that is the view model for the login screen.
/// It extends [ChangeNotifier] so it could notify listener[LoginScreen] if there
/// is any change
class LoginScreenModel with ChangeNotifier {
  final AuthBase? authBase;
  SigninFormState formState;
  String email;
  String password;
  String name;
  String confirmPassword;
  bool isLoading;
  bool submitted;

  ///the only class constructor the is expose to external APIs
  LoginScreenModel(
      {@required this.authBase,
      this.formState = SigninFormState.login,
      this.password = '',
      this.confirmPassword = '',
      this.email = '',
      this.name = '',
      this.isLoading = false,
      this.submitted = false});

  ///update email
  void updateEmail(String email) => _copyWith(email: email);

  ///update  password
  void updatePassword(String password) => _copyWith(password: password);

  ///update confirm password text
  void updateConfirmPassword(String password) =>
      _copyWith(confirmPassword: password);

  ///update name
  void updateName(String name) => _copyWith(name: name);

  ///get the email label
  String get emailLabel => 'Email';

  ///get the password label
  String get passwordLabel => "Password";

  ///confirm password text label
  String get confirmPasswordLabel => "Confirm Password";

  String get nameLabel => "Name";

  ///email error message
  String? get emailErrorMessage =>
      submitted && email.trim().length < 7 ? "Email too short" : null;

  ///password error message
  String? get passwordErrorMessage {
    final errorText = 'Password should\'nt be less than 7';
    if (formState == SigninFormState.login) {
      return submitted && password.trim().length < 7 ? errorText : null;
    } else {
      // if (password == confirmPassword) {
      return submitted && password.trim().length < 7 ? errorText : null;
      // } else {
      //   return submitted ? "Passwords do not match":null;
      // }
    }
  }

  String? get nameErrorMessage {
    return null;
  }

  ///confirm password error message
  String? get confirmPasswordErrorMessage {
    //if the form state is login return null always
    if (formState == SigninFormState.login) {
      return null;
    } else {
      if (password.trim() != confirmPassword.trim()) {
        return "Passwords do not match";
      } else {
        return submitted && password.trim().length < 7
            ? 'Password should\'nt be less than 7'
            : null;
      }
    }
  }

  ///submit button label
  String get submitButtonLabel => _haveAnAccount ? "Login" : "Register";

  ///gets the string for the question of have account or not
  String get haveAccountOrNotLabel =>
      _haveAnAccount ? "Don't have an account?" : "Have ana account?";

  ///get the string for the toggle button
  String get toggleButtonLabel => _haveAnAccount ? "Register" : "Sign-in";
  String get displayLabel=> _haveAnAccount?"Log-in": "Registration";

  ///private getter that checks the state of the form
  bool get _haveAnAccount => formState == SigninFormState.login ? true : false;

  ///getter for that returns true if confirm password TextField widget is to be shown
  ///or false otherwise
  bool get showConfirmPassword => !_haveAnAccount;

  ///toggle the form state between login and register
  void toggleFormState() {
    //set submitted to false so the error messages disappear
    _copyWith(submitted: false);
    formState == SigninFormState.login
        ? _copyWith(formState: SigninFormState.register)
        : _copyWith(formState: SigninFormState.login);
  }

  ///[registerOrLoginUser] signs in or registers a new user depending on the state
  ///of the [formState]
  Future<FirebaseUser> registerOrLoginUser() async {
    FirebaseUser? _user;
    //set isLoading to true so there can be indicator that it is loading
    //set submitted to true so error message can be displayed
    _copyWith(isLoading: true, submitted: true);

    try {
      if (this.formState == SigninFormState.login) {
        if (emailErrorMessage != null || passwordErrorMessage != null) {
          //set [isLoading] to false
          _copyWith(isLoading: false);
          throw PlatformException(
              code: 'Login Error', message: "Please fill all fields properly");
        }
        _user = await authBase!
            .signinUserWithEmailAndPassword(this.email, this.password);
      } else {
        ///form state is sign up(register)
        if (emailErrorMessage != null ||
            passwordErrorMessage != null ||
            confirmPasswordErrorMessage != null ||
            nameErrorMessage != null) {
          //set [isLoading] to false
          _copyWith(isLoading: false);
          throw PlatformException(
              code: 'Register Error',
              message: "Please fill all fields properly");
        }
        _user = await authBase!
            .createUserWithEmailAndPassword(this.email, this.password);
        ///write the name of the user to the firestore
        await authBase!.updateUserName(name);
      }
      //set [isLoading] to false
      _copyWith(isLoading: false);

      return _user!;
    } catch (error) {
      //set [isLoading] to false
      _copyWith(isLoading: false);
      rethrow;
    } finally {}
  }

  ///a private method that can change the field or fields of [this] class
  void _copyWith(
      {SigninFormState? formState,
      String? email,
      String? password,
      String? confirmPassword,
      String? name,
      bool? isLoading,
      bool? submitted}) {
    //set the values of the class fields to the one of the [_copyWith] method
    //if not null else use the already existing fields values
    this.formState = formState ?? this.formState;
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.name = name ?? this.name;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    //notify the listener of the change
    notifyListeners();
  }
}
