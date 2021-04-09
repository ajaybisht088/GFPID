import 'package:db_test3/user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'sign_up.dart';
import 'first_page.dart';
import 'file_testing.dart';
import 'second_page.dart';
import 'bt_main.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var routes = <String, WidgetBuilder>{
    //   SignUpPage.routeName: (BuildContext context) => new SignUpPage(title: "SignUpPage"),
    // };
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // backgroundColor: Colors.blueGrey.shade100,
          // bottomAppBarColor: Colors.blueGrey.shade100,
        ),
        color: Colors.blueGrey.shade100,
        home: MyHomePage(title: 'ATAI'),
        debugShowCheckedModeBanner: false,
        // home: MyFileList(title: 'ATAI'),
        // home: FirstPage(title: 'ATAI'),
        // routes: routes,
        routes: <String, WidgetBuilder>{
          SignUpPage.routeName: (context) => SignUpPage(title: "Sign Up"),
          FirstPage.routeName: (context) => FirstPage(title: "First Page"),
          ViewPage.routeName: (context) => ViewPage(title: "File Testing"),
          // SecondPage.routeName: (context) => SecondPage(title: "File Testing",
          //   newPath: filePath),
          SecondPage.routeName: (context) => SecondPage(title: "File Testing",),
          BtMain.routeName: (context) => BtMain(title: "File Testing"),
        },
      ),
    );
  }
}
