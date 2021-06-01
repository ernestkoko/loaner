import 'package:flutter/material.dart';

///a custom alert dialog widget
class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final Function? defaultActionPressed;
  final String? defaultActionText;

  const CustomAlertDialog({Key? key,
    this.title = 'Title',
    this.content = 'Content',
    this.defaultActionPressed,
    this.defaultActionText, this.cancelText = 'Ok'})
      : super(key: key);

  ///this called to return this class
  Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildAction(context),
    );
  }

  List<Widget> _buildAction(BuildContext context) {
    List<Widget> widgets = [];
    if (defaultActionPressed != null) {
      widgets.add(ElevatedButton(
          onPressed: () => defaultActionPressed,
          child: Text(defaultActionText!)));
    }
    widgets.add(ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text(cancelText)));

    return widgets;
  }
}
