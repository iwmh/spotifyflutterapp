import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings page!'),
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            color: Colors.grey,
            child: Text(
              "settings",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            padding: EdgeInsets.all(20),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
