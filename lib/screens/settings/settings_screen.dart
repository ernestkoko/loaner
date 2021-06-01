import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static final route = 'settings_route';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text('Change Name'),
            ],
          ),
        ));
  }
}
