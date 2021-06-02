import 'package:flutter/material.dart';
import 'screens/addOffer/addOffer.dart';
import 'screens/editProfile/editProfile.dart';
import 'screens/splash/splash.dart';
import 'screens/homepage/homepage.dart';
import 'screens/login/login.dart';
import 'screens/register/register.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (BuildContext context) => LoginScreen(),
        '/register': (BuildContext context) => RegisterScreen(),
        '/editProfile': (BuildContext context) => EditProfileScreen(),
        '/homepage': (BuildContext context) => HomepageScreen(),
        '/addOffer': (BuildContext context) => AddOfferScreen(),
      },
    );
  }
}
