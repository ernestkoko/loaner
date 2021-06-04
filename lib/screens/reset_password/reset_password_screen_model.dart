import 'package:flutter/foundation.dart';
import 'package:loaner/repositories/firebase_repository.dart';

class ResetPasswordScreenModel extends ChangeNotifier {
  final AuthBase? auth;
  String password;
  String newPassword;
  bool loading;
  bool submitted;

  ResetPasswordScreenModel(
      {this.auth,
      this.password = '',
      this.newPassword = '',
      this.loading = false,
      this.submitted = false});

  String get passwordLabel => "Password";

  String get newPasswordLabel => "New password";

  String get confirmPasswordLabel => "Confirm password";

  String? get oldPasswordErrorMessage {
    if (submitted && this.password.length < 7) {
      return "Password is too short";
    } else
      return null;
  }

  ///method that gets fired every time the text in old password Text field widget changes
  set setOldPassword(String password) {
    _copyWith(password: password);
  }

  ///method that gets fired every time the text in new password Text field widget changes
  set setNewPassword(String newPassword) {
    _copyWith(newPassword: newPassword);
  }

  Future  changePassword() async {
    try {
      await auth!.updatePassword(
          newPassword: this.newPassword, oldPassword: this.password);
    } catch (error) {
      rethrow;
    }
  }

  ///method that can change the internal members of [this] class
  void _copyWith(
      {String? password, String? newPassword, bool? loading, bool? submitted}) {
    this.password = password ?? this.password;
    this.newPassword = newPassword ?? this.newPassword;
    this.loading = loading ?? this.loading;
    this.submitted = submitted ?? this.submitted;

    ///notify listeners
    notifyListeners();
  }
}
