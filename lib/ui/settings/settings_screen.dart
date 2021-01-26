import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings page'),
        automaticallyImplyLeading: false,
        centerTitle: true,
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
  }
}
