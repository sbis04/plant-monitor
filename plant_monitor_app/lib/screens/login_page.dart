import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_tinker/res/palette.dart';
import 'package:plant_tinker/utils/authentication.dart';
import 'package:plant_tinker/widgets/google_sign_in_button.dart';

import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Palette.blue_gray,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.blue_gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PlantTinker',
                      style: TextStyle(
                        color: Palette.neon_green,
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(),
                    ),
                  );
                },
                child: Text('Dashboard'),
              ),
              // FutureBuilder(
              //   future: Authentication.initializeFirebase(context: context),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       return Text('Error initializing Firebase');
              //     } else if (snapshot.connectionState == ConnectionState.done) {
              //       return GoogleSignInButton();
              //     }
              //     return CircularProgressIndicator(
              //       valueColor: AlwaysStoppedAnimation<Color>(
              //         Palette.neon_green,
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
