import 'package:flutter/material.dart';

class SettingsPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('settings page!'),
            automaticallyImplyLeading: false,
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
      },
    );
  }
}
