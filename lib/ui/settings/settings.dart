import 'package:flutter/material.dart';

class SettingsPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('settings page!'),
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: GestureDetector(
              child: Container(
                color: Colors.grey,
                child: const Text(
                  "settings",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                padding: const EdgeInsets.all(20),
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}
