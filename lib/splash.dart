import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart' as give_permission;
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'path_support.dart';
import 'package:location/location.dart';
class HyGSplash extends StatefulWidget {
  @override
  _HyGSplashState createState() => _HyGSplashState();
}

class _HyGSplashState extends State<HyGSplash> {
  final db_helper = DataBaseHelper.instance;
  @override
  void initState() {
    super.initState();
    splashTime();
    autoLogIn();
  }


  Future<bool> _requestPermission(give_permission.Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      // var result = await permission.request();
      if (await permission.request().isGranted) {
        return true;
      }
    }
    return false;
  }



  var location = Location();
  autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');
    final String userPassword = prefs.getString('userpassword');
    if (userId != null) {
      var result = await db_helper.verify_userabc(userId, userPassword);
      if (result == 'valid user') {
        setState(() {
          isLoggedIn = true;
        });
        return;
      }
    }
    // if (userId != null) {
    //   setState(() {
    //     isLoggedIn = true;
    //   });
    //   return;
    // }
  }
  @override
  Widget build(BuildContext context) {
    //Uncomment this line to enable full screen
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
       //     Image.asset("images/splash_background.png", fit: BoxFit.fill),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Image.asset("images/tunnel.png"),
                height: 150.00,
                width: 150.00,
              ),
            )
          ],
        ),
      ),
    );
  }

  splashTime() async{
    (_requestPermission(give_permission.Permission.storage));
  //  ( (give_permission.Permission.storage));
 //   (storage.requestPermission());
   // (location.requestPermission());

    var _duration = new Duration(seconds: 3);
    (location.requestPermission());
    return new Timer(_duration, callback);
  }

  void callback() async{
 //   final SharedPreferences prefs = await SharedPreferences.getInstance();
   // final bool isLoggedIn = (prefs.getBool('isLoggedIn') ?? false);
/*
    isLoggedIn
        ? FirstPage(title: "First Page")
        : MyHomePage(title: 'Login'),
  */
    (isLoggedIn) ? Navigator.pushReplacementNamed(context,'/FirstPage') : Navigator.pushReplacementNamed(context,'/MyHomePage');
    // Navigator.pushReplacementNamed(context,'/CheckAppointment');
  }
}
