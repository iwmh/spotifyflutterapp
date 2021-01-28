import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:spotifyflutterapp/services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Widget> items;
  ApiService apiService;

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Do you really log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  // delete all stored token-related info.
                  apiService.deleteAllDataInStorage();
                  // restart the app
                  Phoenix.rebirth(context);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red[400]),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // obtain the service
    apiService = Provider.of<ApiService>(context, listen: false);

    // items to show
    items = [
      const ListTile(
        title: Text(
          'Others',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        isThreeLine: false,
      ),
      ListTile(
        title: const Text('Logout'),
        subtitle: Text('Logged in as ' + apiService.displayName),
        isThreeLine: false,
        onTap: _showDialog,
      ),
    ];

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
      body: ListView(
        children: items,
      ),
    );
  }
}
