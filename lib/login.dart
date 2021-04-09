import 'package:db_test3/sign_up.dart';
import 'first_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db_helper = DataBaseHelper.instance;
  String loginErrorMessage = "";

  void verify_user() async {
    print("login_username_controller = ${login_username_controller.text} "
        "and login_password_controller = ${login_password_controller.text}");
    var result = await db_helper.verify_userabc(
        login_username_controller.text, login_password_controller.text);
    print(result);
    login_username_controller.text = "";
    login_password_controller.text = "";
    if (result == 'valid user')
      Navigator.pushNamed(context, FirstPage.routeName);
    // if (result == 'valid user') Navigator.pushNamed(context, MyFileList.routeName);
    else {
      loginErrorMessage = result;
      _showMessage(context);
    }
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
        backgroundColor: Colors.blueGrey.shade600,
      ),
      backgroundColor: Colors.blueGrey.shade200,
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor :Colors.blueGrey.shade100,),
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(1.0),
        // child: Container(
        // child: new Container(
        //   alignment: Alignment.topCenter,
        //   color: Colors.blueGrey.shade100,
          // margin: EdgeInsets.all(10.0),
          // padding: EdgeInsets.all(10.0),
          // decoration: BoxDecoration(
          //   color: Colors.blueGrey.shade100,
            // borderRadius: BorderRadius.circular(14.0),
          // ),
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
      // width: 400,
      // height: 400,
      alignment: Alignment.center,
      margin: EdgeInsets.all(1.0),
      padding: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.circular(14.0),
      ),
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
                  prefixIcon: Icon(Icons.account_circle, color: Colors.white),
                  labelText: "Username",
                  labelStyle: TextStyle(color: Colors.white),
                  focusColor: Colors.blueGrey.shade600,
                  // hintStyle: TextStyle(color: Colors.white10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                        BorderSide(color: Colors.blueGrey.shade400, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                        BorderSide(color: Colors.blueGrey.shade400, width: 2),
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
                  prefixIcon: Icon(Icons.vpn_key, color: Colors.white),
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                        BorderSide(color: Colors.blueGrey.shade400, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide:
                        BorderSide(color: Colors.blueGrey.shade400, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please Enter Password";
                  return null;
                },
              ),
              SizedBox(
                height: 20,
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
                  backgroundColor: Colors.blueGrey.shade400,
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
                  backgroundColor: Colors.blueGrey.shade400,
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
        color: Colors.blueGrey.shade400,
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
        // alignment: Alignment.center,
        // color: Colors.amberAccent,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade400,
          // color: Colors.amberAccent,
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          border: Border.all(color: Colors.blueGrey.shade400),
        ),
        child: FittedBox(
          child: Icon(
            Icons.account_circle_rounded,
            color: Colors.blueGrey.shade100,
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
