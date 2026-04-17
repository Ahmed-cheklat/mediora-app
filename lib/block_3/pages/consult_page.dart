import 'package:flutter/material.dart';
import 'package:mediora/Network/networkServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultPage extends StatelessWidget {
  const ConsultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            print('""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
            print('BEFORE - Access Token : ${prefs.getString("access_token")}');
            print('BEFORE - Refresh Token : ${prefs.getString("refresh_token")}');
            print('""""""""""""""""""""""""""""""""""""""""""""""""""""""""');

            final result = await AuthService().getRefreshToken();
            print('Result: ${result.success} - ${result.message}');

            print('""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
            print('AFTER - Access Token : ${prefs.getString("access_token")}');
            print('AFTER - Refresh Token : ${prefs.getString("refresh_token")}');
            print('""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
          },
          child: Text('Check'),
        ),
      ),
    );
  }
}
