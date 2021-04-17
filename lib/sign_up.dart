import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
import 'database_helper.dart';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/SignUpPage";
  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final db_helper = DataBaseHelper.instance;
  String encodedAndroidId = "";
  String userUpdates = "";
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  Future<void> deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    encodedAndroidId =
        stringToBase64.encode(stringToBase64.encode(androidInfo.androidId));
    print(encodedAndroidId);
  }

  void insert_data() async {
    try {
      Map<String, dynamic> row = {
        DataBaseHelper.columnName: username_controller.text,
        DataBaseHelper.columnPassword: password_controller.text,
        DataBaseHelper.columnEmail: email_controller.text,
        DataBaseHelper.columnSecretKey: stringToBase64
            .decode(stringToBase64.decode(secretkey_controller.text)),
      };
      userUpdates = await db_helper.insert(row);
      print(userUpdates);
      if (userUpdates == 'updated') {
        userUpdates = "User ${username_controller.text} Updated";
        username_controller.text = "";
        password_controller.text = "";
        email_controller.text = "";
        secretkey_controller.text = "";
        _showInfo(context);
      }
      if (userUpdates == 'created') {
        userUpdates = "User ${username_controller.text} Created";
        username_controller.text = "";
        password_controller.text = "";
        email_controller.text = "";
        secretkey_controller.text = "";
        _showInfo(context);
      }
    } catch (e) {
      _showWrongKeyPopUp(context);
    }
  }

  void queryall() async {
    var all_rows = await db_helper.query_all();
    all_rows.forEach((element) {
      print(element);
    });
  }

  final _formKey = GlobalKey<FormState>();
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
  final email_controller = TextEditingController();
  final secretkey_controller = TextEditingController();

  // final android_id_controller = TextEditingController(text: "hello");

  // var username = "";
  // var password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF204C97),
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: new SingleChildScrollView(
        // child: Container(
        //   alignment: Alignment(0.0, 0.0),
        //   margin: EdgeInsets.all(10.0),
        //   child: Container(
        //     alignment: Alignment(0.0, 0.0),
        //     margin: EdgeInsets.all(10.0),
        //     // padding: EdgeInsets.all(1.0),
        //     decoration: BoxDecoration(
        //       color: Colors.blueGrey.shade100,
        //       borderRadius: BorderRadius.circular(14.0),
        //     ),
        child: new Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new TextFormField(
                    // enabled: false,
                    controller: username_controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                      ),
                      labelText: "Username",
                      //labelStyle: TextStyle(color: Colors.white),
                      focusColor: Color(0xFF204C97),
                      filled: true,
                      fillColor: Colors.white70,
                      // hintStyle: TextStyle(color: Colors.white10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        borderSide:
                            BorderSide(color: Color(0xFF204C97), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(
                            color: Colors.blueGrey.shade400, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) return "Please Enter Username";
                      return null;
                    },
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: password_controller,
                    decoration: InputDecoration(
                      // icon: Icon(Icons.account_circle),
                      prefixIcon: Icon(
                        Icons.vpn_key,
                      ),
                      labelText: "Password",
                      // labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white70,
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
                  new SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: email_controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      labelText: "Email ID",
                      // labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white70,
                      focusColor: Color(0xFF204C97),
                      // hintStyle: TextStyle(color: Colors.white10),
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
                      if (value.isEmpty) return "Please Enter Email ID";
                      return null;
                    },
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    controller: secretkey_controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.vpn_key_outlined,
                      ),
                      labelText: "Secret Key",
                      //  labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white70,
                      focusColor: Color(0xFF204C97),
                      // hintStyle: TextStyle(color: Colors.white10),
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
                      if (value.isEmpty) return "Please Enter Secret Key";
                      return null;
                    },
                  ),
                  new SizedBox(
                    height: 60,
                  ),
                  new SizedBox(
                    width: 300,
                    height: 60,
                    child: new FloatingActionButton.extended(
                      onPressed: insert_data,
                      label: Text(
                        "Create/Update",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      backgroundColor: Color(0xFF204C97),
                      heroTag: null,
                    ),
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  new SizedBox(
                    width: 300,
                    height: 60,
                    child: new FloatingActionButton.extended(
                      onPressed: () async {
                        await deviceInfo();
                        _showPartialKey(context);
                      },
                      label: Text(
                        "View App Id",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      backgroundColor: Color(0xFF204C97),
                      heroTag: null,
                    ),
                  ),
                  new SizedBox(
                    height: 20,
                  ),
                  // new SizedBox(
                  //   width: 300,
                  //   height: 60,
                  //   child: new FloatingActionButton.extended(
                  //     onPressed: queryall,
                  //     label: Text(
                  //       "VIEW USERS",
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //       ),
                  //     ),
                  //     backgroundColor: Colors.blueGrey.shade400,
                  //     heroTag: null,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        //   ),
        // ),
      ),
    );
  }

  _showPartialKey(BuildContext context) {
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
      title: Text("Copy App ID : "),
      // content: Text("Work in Progress."),
      content: SelectableText(
        encodedAndroidId,
        onTap: () {
          // Clipboard.setData(new ClipboardData(text: encodedAndroidId));
          // you can show toast to the user, like "Copied"
        },
      ),
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

  _showWrongKeyPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Invalid Secretkey !'),
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

  _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(userUpdates),
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
}
