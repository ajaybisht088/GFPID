import 'package:shared_preferences/shared_preferences.dart';
import 'package:db_test3/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'database_helper.dart';
import 'login.dart';
import 'sign_up.dart';
import 'first_page.dart';
import 'file_testing.dart';
import 'second_page.dart';
import 'bt_main.dart';
import 'path_support.dart';
import 'splash.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool isLoggedIn = false;
  final db_helper = DataBaseHelper.instance;

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: MaterialApp(
        //     return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        color: Colors.blueGrey.shade100,
        home:HyGSplash(),
        /*
        isLoggedIn
            ? FirstPage(title: "First Page")
            : MyHomePage(title: 'Login'),

         */
        // home: MyHomePage(title: 'Login'),
        debugShowCheckedModeBanner: false,
        // home: FirstPage(title: 'ATAI'),
        // routes: routes,
        routes: {
          "/MyHomePage": (_) => new MyHomePage(title: "Login"),
          SignUpPage.routeName: (context) => new SignUpPage(title: "Sign Up"),
          FirstPage.routeName: (context) => new FirstPage(title: "First Page"),
          ViewPage.routeName: (context) => new ViewPage(title: "File Testing"),
          // SecondPage.routeName: (context) => SecondPage(title: "File Testing",
          //   newPath: filePath),
          SecondPage.routeName: (context) =>
              SecondPage(
                title: "File Testing",
              ),
          BtMain.routeName: (context) => BtMain(title: "File Testing"),
        },
      ),
    );
  }
}
