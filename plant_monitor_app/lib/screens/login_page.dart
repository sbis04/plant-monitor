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
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.blue_gray,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: SizedBox(
              height: double.maxFinite,
              child: Image.asset(
                'assets/plant_background.jpeg',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SafeArea(
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
                          'Plant Monitor',
                          style: TextStyle(
                            fontFamily: 'DancingScript',
                            color: Palette.neon_green,
                            fontWeight: FontWeight.w700,
                            fontSize: 55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Palette.green_accent),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Get data',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
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
        ],
      ),
    );
  }
}
