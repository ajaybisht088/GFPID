import 'package:db_test3/path_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:db_test3/sign_up.dart';
import 'first_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  static const String routeName = "/MyHomePage";
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db_helper = DataBaseHelper.instance;
  String loginErrorMessage = "";

  void verify_user() async {
    // print("login_username_controller = ${login_username_controller.text} "
    //     "and login_password_controller = ${login_password_controller.text}");
    var result = await db_helper.verify_userabc(
        login_username_controller.text, login_password_controller.text);
    // print(result);
    if (result == 'valid user') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', login_username_controller.text);
      prefs.setString('userpassword', login_password_controller.text);
      isLoggedIn = true;
      // print("context = $context");
      Navigator.pushNamedAndRemoveUntil(
          context, FirstPage.routeName, (_) => false);
    }
    else {
      loginErrorMessage = result;
      _showMessage(context);
    }
    login_username_controller.text = "";
    login_password_controller.text = "";
    // else print('invalid user');
    // var dataList = await db_helper.getNoteList(login_username_controller.text);
    // print(dataList);
  }

  final _formKey = GlobalKey<FormState>();
  final login_username_controller = TextEditingController();
  final login_password_controller = TextEditingController();

  // var username = "";
  // var password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF204C97),
        // backgroundColor: Color(0xFF204C97),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.blueGrey.shade100,
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor :Colors.blueGrey.shade100,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _logoTop(),
            // Divider(),
            SizedBox(height: 30,),
            _getcard(),
          ],
        ),
      ),
      // ),
      // ),
    );
  }

  Container _getcard() {
    return new Container(
      child: Form(
        key: _formKey,
        // child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: login_username_controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle,
                    //    color: Colors.white
                  ),
                  labelText: "Username",
                  filled: true,
                  fillColor: Colors.white70,
                  //labelStyle: TextStyle(color: Colors.white),
                  focusColor: Colors.blueGrey.shade600,
                  // hintStyle: TextStyle(color: Colors.white10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                    BorderSide(color:Color(0xFF204C97), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                    BorderSide(color: Color(0xFF204C97), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please Enter Username";
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: login_password_controller,
                decoration: InputDecoration(
                  // icon: Icon(Icons.account_circle),
                  filled: true,
                  fillColor: Colors.white70,
                  prefixIcon: Icon(Icons.vpn_key, ),
                  //color: Colors.white),
                  labelText: "Password",
                  //labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                    BorderSide(color: Color(0xFF204C97), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                    BorderSide(color: Color(0xFF204C97), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please Enter Password";
                  return null;
                },
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: new FloatingActionButton.extended(
                  onPressed: verify_user, //insert_data,
                  label: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  backgroundColor: Color(0xFF204C97),
                  heroTag: null,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: new FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, SignUpPage.routeName);
                  },
                  label: Text(
                    "SIGN UP",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  backgroundColor: Color(0xFF204C97),
                  heroTag: null,
                ),
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }

  // Container _logoTop() {
  //   return new Container(
  //     // width: 200,
  //     // height: 200,
  //     // alignment: Alignment.center,
  //     // color: Colors.amberAccent,
  //     decoration: BoxDecoration(
  //       color: Colors.blueGrey.shade100,
  //       // color: Colors.amberAccent,
  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //       border: Border.all(color: Colors.blueGrey.shade100),
  //     ),
  //     constraints: BoxConstraints.expand(width: 150.0, height: 150.0),
  //     child: FittedBox(
  //       child: Icon(
  //         Icons.account_circle_rounded,
  //         color: Colors.blueGrey.shade400,
  //       ),
  //     ),
  //   );
  // }
  Container _logoTop() {
    return new Container(
      // width: 340,
      height: 220,
      alignment: Alignment.center,
      // color: Colors.amberAccent,
      decoration: BoxDecoration(
        color: Color(0xFF204C97),
        // color: Colors.amberAccent,
        // borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.circular(70.0),
          bottomRight: Radius.zero,
        ),
        // border: Border.all(color: Colors.blueGrey.shade400),
      ),
      // constraints: BoxConstraints.expand(width: 150.0, height: 150.0),
      child: new Container(
        width: 150,
        height: 150,
        child: FittedBox(
          child: Icon(
            Icons.account_circle_rounded,
            color: Colors.blueGrey.shade100,
            //  color: Color(0xFF246C8B),
          ),
        ),
      ),
    );
  }

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Alert Message Title Text.'),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _showMessage(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        // Navigator.of(context).pushNamed('/HomePage');
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("Alert "),
      content: Text(loginErrorMessage),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
