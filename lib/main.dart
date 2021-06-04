import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loaner/screens/active_loan/active_loan_model.dart';
import 'package:loaner/screens/reset_password/reset_password_screen.dart';
import 'package:loaner/screens/reset_password/reset_password_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../repositories/firebase_repository.dart';
import '../screens/active_loan/active_loan_screen.dart';
import '../screens/home/home_model.dart';
import '../screens/home/home_screen.dart';
import '../screens/loan/loan_model.dart';
import '../screens/loan/loan_screen.dart';
import '../screens/login/login_model.dart';
import '../screens/login/login_screen.dart';
import '../screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //return a multi-provider widget that has materialApp as child
    return MultiProvider(
      ///register all the view models
      providers: <SingleChildWidget>[
        Provider<AuthBase>(
          create: (_) => FirebaseAuthentication(),
        ),
        ChangeNotifierProxyProvider<AuthBase, LoginScreenModel>(
            create: (_) => LoginScreenModel(),
            update: (_, authBase, model) =>
                LoginScreenModel(authBase: authBase)),
        ChangeNotifierProxyProvider<AuthBase, HomeScreenModel>(
          create: (_) => HomeScreenModel(),
          update: (_, auth, child) => HomeScreenModel(auth: auth),
        ),
        ChangeNotifierProxyProvider<AuthBase, LoanScreenModel>(
          create: (ctx) => LoanScreenModel(),
          update: (ctx, auth, model) => LoanScreenModel(auth: auth),
        ),
        ChangeNotifierProxyProvider<AuthBase, ActiveLoanScreenModel>(
            create: (_) => ActiveLoanScreenModel(),
            update: (ctx, auth, model) => ActiveLoanScreenModel(auth: auth)),
        ChangeNotifierProxyProvider<AuthBase, ResetPasswordScreenModel>(
            create: (context) => ResetPasswordScreenModel(),
            update: (BuildContext ctx, auth, model) =>
                ResetPasswordScreenModel(auth: auth))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loaner App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        ///return a stream builder that watches for when User is null or not
        ///and build the needed widget in each case
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            ///when the connection state is wait a progress indicator is shown
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            ///is the User is not null,there is user, go to home screen
            if (snapshot.data != null) {
              return HomeScreen();
            }

            ///if the user is null, go to login screen
            return LoginScreen();
          },
        ),

        ///register the different navigation routes/pages for the app
        routes: {
          HomeScreen.route: (BuildContext ctx) => HomeScreen(),
          LoginScreen.route: (ctx) => LoginScreen(),
          SettingsScreen.route: (BuildContext ctx) => SettingsScreen(),
          LoanScreen.route: (BuildContext ctx) => LoanScreen(),
          ActiveLoanScreen.route: (BuildContext ctx) => ActiveLoanScreen(),
          ResetPasswordScreen.route: (BuildContext context) =>
              ResetPasswordScreen()
        },
      ),
    );
  }
}
