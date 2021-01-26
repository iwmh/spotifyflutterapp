import 'package:flutter/material.dart';
import 'package:spotifyflutterapp/ui/settings/settings_screen.dart';

class SettingsPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return SettingsScreen();
      },
    );
  }
}
