import 'package:flutter/material.dart';
import 'package:spotifyflutterapp/ui/home/home_screen.dart';

class HomePage extends Page {
  final ValueChanged<String> onTapped;
  const HomePage({@required this.onTapped});

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return HomeScreen(onTapped);
      },
    );
  }
}
