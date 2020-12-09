import 'package:flutter/material.dart';

class PlaylistPage extends Page {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('tracks page!'),
  //     ),
  //     body: Container(),
  //   );
  // }

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, _, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('tracks page!'),
          ),
          body: Container(),
        );
      },
    );
  }
}
