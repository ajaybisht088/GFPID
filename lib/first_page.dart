import 'package:db_test3/ChatPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as give_permission;
import 'dart:io';
import 'file_testing.dart';
import 'second_page.dart';
import 'bt_main.dart';
import 'path_support.dart';

String filePath = "";

class FirstPage extends StatefulWidget {
  FirstPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/FirstPage";
  final String title;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var _dropA = ["None"];
  var _dropB = ["None"];
  var _dropC = ["None"];
  var _directory;
  List _file = new List();
  String _newPath = "";
  var _currentValueSelectedA;
  var _currentValueSelectedB;
  var _currentValueSelectedC;
  int _radioValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _granted_permission();
    _listofFiles();
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

  // Make New Function
  void _listofFiles() async {
    if (Platform.isAndroid) {
      if (await _requestPermission(give_permission.Permission.storage)) {
        _directory = await getExternalStorageDirectory();
        _newPath = "";
        print(_directory);
        List<String> paths = _directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            _newPath += "/" + folder;
          } else {
            break;
          }
        }
        _newPath = _newPath + "/GPS_DATA/Railways/";
        _directory = Directory(_newPath).path;
        print('directory = $_directory');
        var raw_lista = Directory(_directory).listSync();
        print(raw_lista);
        setState(() {
          _dropA = ["None"];
          for (int i = 0; i < raw_lista.length; i++) {
            _dropA.add((raw_lista[i].path).split('/').last);
          }
          print(_dropA);
        });
      } else {
        return;
      }
    }
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;

        case 1:
          break;

        case 2:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Route'),
          backgroundColor: Colors.blueGrey.shade600,
        ),
        backgroundColor: Colors.blueGrey.shade100,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      //    padding: EdgeInsets.all(7),
                      alignment: Alignment.center,
                      // color: Colors.yellow,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.blue, width: 3,),
                              shape: BoxShape.rectangle,
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Select R :",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.blue, width: 3,),
                              shape: BoxShape.rectangle,
                              // color: Colors.blueAccent,
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Select D :",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.blue, width: 3,),
                              shape: BoxShape.rectangle,
                              // color: Colors.blueAccent,
                              color: Colors.transparent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Select S :",
                              style: TextStyle(
                                fontSize: 22,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            // color: Colors.redAccent,
                          //   alignment: Alignment.center,
                          //   DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                // iconEnabledColor: Colors.redAccent,
                                items: _dropA.map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(
                                      dropDownStringItem,
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String newValueSelected) {
                                  setState(() {
                                    _currentValueSelectedA = newValueSelected;
                                    _directory = Directory(_newPath +
                                            _currentValueSelectedA +
                                            '/')
                                        .path;
                                    print('directory = $_directory');
                                    var raw_lista =
                                        Directory(_directory).listSync();
                                    print(raw_lista);
                                    _dropB = [];
                                    for (int i = 0; i < raw_lista.length; i++) {
                                      _dropB.add(
                                          (raw_lista[i].path).split('/').last);
                                    }
                                  });
                                  print(_currentValueSelectedA);
                                },
                                value: _currentValueSelectedA,
                                //validator: (value) => value == null ? 'field required' : null,
                              ),
                            ),
                          // ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            child: DropdownButton<String>(
                              items: _dropB.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  _currentValueSelectedB = newValueSelected;
                                  _directory = Directory(_newPath +
                                          _currentValueSelectedA +
                                          '/' +
                                          _currentValueSelectedB +
                                          '/')
                                      .path;
                                  print('directory = $_directory');
                                  var raw_lista =
                                      Directory(_directory).listSync();
                                  print(raw_lista);
                                  _dropC = [];
                                  for (int i = 0; i < raw_lista.length; i++) {
                                    _dropC.add(
                                        (raw_lista[i].path).split('/').last);
                                  }
                                });
                              },
                              value: _currentValueSelectedB,
                              //validator: (value) => value == null ? 'field required' : null,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            child: DropdownButton<String>(
                              items: _dropC.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropDownStringItem,
                                  child: Text(
                                    dropDownStringItem,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  _currentValueSelectedC = newValueSelected;
                                });
                              },
                              value: _currentValueSelectedC,
                              //validator: (value) => value == null ? 'field required' : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                    alignment: Alignment.center,
                    height: 60,
                    // color: Colors.yellow,
                    // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      // textColor: Colors.white,
                      // color: Colors.blueAccent,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                          textStyle: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      child: Text(
                        'Report',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_currentValueSelectedA != null) {
                          if (_currentValueSelectedB != null) {
                            if (_currentValueSelectedC != null) {
                              // setState(() {
                              filePath = _newPath +
                                  _currentValueSelectedA +
                                  '/' +
                                  _currentValueSelectedB +
                                  '/' +
                                  _currentValueSelectedC +
                                  '/';
                              // newPath = filePath;
                              // myFilePath = filePath; // bluetooth chatpage
                              Navigator.pushNamed(context, ViewPage.routeName);
                              // });
                            }
                          }
                        }
                      },
                    )),
                SizedBox(height: 70),
                Container(
                    // height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 3,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      color: Colors.white10,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[
                      Container(
                        width: 145,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.blue, width: 3,),
                          shape: BoxShape.rectangle,
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "GPS",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            new Text(
                              'Internal',
                              style: new TextStyle(fontSize: 22.0),
                            ),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange,
                            ),
                            new Text(
                              'External',
                              style: new TextStyle(
                                fontSize: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])),
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.center,
                    height: 60,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      // textColor: Colors.white,
                      // color: Colors.blueAccent,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          padding:
                              EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                          textStyle: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      child: Text(
                        'GO',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        // print('radiovalue : $_radioValue');
                        // setState(() {
                        filePath = _newPath +
                            _currentValueSelectedA +
                            '/' +
                            _currentValueSelectedB +
                            '/' +
                            _currentValueSelectedC +
                            '/';
                        newPath = filePath;
                        fileName = _currentValueSelectedA +
                            '_' +
                            _currentValueSelectedB +
                            '_' +
                            _currentValueSelectedC +
                            '_';
                        // _currentValueSelectedA = null;
                        // _currentValueSelectedB = null;
                        // _currentValueSelectedC = null;
                        // });
                        print('filePath = $filePath');
                        if (_radioValue == 0) {
                          Navigator.pushNamed(context, SecondPage.routeName);
                        } else {
                          Navigator.pushNamed(context, BtMain.routeName);
                        }
//                                print(nameController.text);
                      },
                    )),
              ]),
        ));
  }
}
