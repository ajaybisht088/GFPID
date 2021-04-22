import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:quiver/async.dart';
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

class _HyGSplashState extends State<HyGSplash> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  final db_helper = DataBaseHelper.instance;
  int _counter = 0;
  int elapsed = 1;

//  AnimationController controller;
  @override
  void initState() {
    super.initState();
    splashTime();
    autoLogIn();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1400), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Padding(
        padding: EdgeInsets.fromLTRB(9, 40, 9, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text("Welcome",
                    style: TextStyle(
                      fontSize: 60,
                      color: Colors.blue,
                      fontFamily: 'MyriadPro',
                      shadows: [
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(3, 3),
                          blurRadius: (4),
                        ),
                      ],
                      fontStyle: FontStyle.italic,
                    )),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: FadeTransition(
                  opacity: animation,
                  child: Image.asset(
                    "images/tunnel.png",
                    height: 280,
                    width: 280,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.center,
                child: Text("INDIAN RAILWAYS",
                    style: TextStyle(
                      fontSize: 44,
                      color: Colors.blue,
                      fontFamily: 'MyriadPro',
                      shadows: [
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(3, 3),
                          blurRadius: (4),
                        ),
                      ],
                      fontStyle: FontStyle.italic,
                      //   fontWeight:FontWeight.bold)
                    )),
              ),
            ),
            Flexible(
              flex: 1,
              // fit: FlexFit.loose,
              //     Image.asset("images/splash_background.png", fit: BoxFit.fill),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 49, 0, 0),
                alignment: Alignment.topCenter,
                child: Text("ATAI INDIA",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontFamily: 'MyriadPro',
                      shadows: [
                        Shadow(
                          color: Colors.grey,
                          offset: Offset(3, 3),
                          blurRadius: (4),
                        ),
                      ],
                      fontStyle: FontStyle.italic,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  splashTime() async {
    (_requestPermission(give_permission.Permission.storage));

    var _duration = new Duration(seconds: 3);
    (location.requestPermission());
    return new Timer(_duration, callback);
  }

  void callback() async {

    (isLoggedIn)
        ? Navigator.pushReplacementNamed(context, '/FirstPage')
        : Navigator.pushReplacementNamed(context, '/MyHomePage');
    // Navigator.pushReplacementNamed(context,'/CheckAppointment');
  }
}
