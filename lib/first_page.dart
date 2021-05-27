import 'package:db_test3/ChatPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as give_permission;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'file_testing.dart';
import 'login.dart';
import 'second_page.dart';
import 'bt_main.dart';
import 'path_support.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

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
  var _sec = "";
  int _radioValue = 0;
  final _formKey = GlobalKey<FormState>();

  String scaff_function(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(msg),
      backgroundColor: Colors.redAccent,
//      backgroundColor: Colors.green.shade500,
      duration: Duration(seconds: 1),
    ));
  }

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
        // print(_directory);
        List<String> paths = _directory.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            _newPath += "/" + folder;
          } else {
            break;
          }
        }
        mastTypePath = _newPath + "/GPS_DATA/MastType/";
        stgrTypePath =
            _newPath + "/GPS_DATA/StgrType/"; //mastType file location path
        _newPath = _newPath + "/GPS_DATA/Railways/";
        _directory = Directory(_newPath).path;
        // print('directory = $_directory');
        var raw_lista = Directory(_directory).listSync();
        // print(raw_lista);
        setState(() {
          _dropA = ["None"];
          for (int i = 0; i < raw_lista.length; i++) {
            _dropA.add((raw_lista[i].path).split('/').last);
          }
          // print(_dropA);
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
        backgroundColor: Color(0xFF204C97),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.logout),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setString('username', null);
              await prefs.setString('userpassword', null);
              // print("context = $context");
              Navigator.pushNamedAndRemoveUntil(
                  context, MyHomePage.routeName, (_) => false);
              isLoggedIn = false;
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        textTheme: TextTheme(
            title: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        )),
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            //    padding: EdgeInsets.all(7),
                            alignment: Alignment.center,
                            // color: Colors.yellow,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    //   border: Border.all(color: Colors.blue, width: 3,),
                                    shape: BoxShape.rectangle,
                                    color: Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Railway :",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 39),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    //   border: Border.all(color: Colors.blue, width: 3,),
                                    shape: BoxShape.rectangle,
                                    // color: Colors.blueAccent,
                                    color: Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Division :",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 37),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    //   border: Border.all(color: Colors.blue, width: 3,),
                                    shape: BoxShape.rectangle,
                                    // color: Colors.blueAccent,
                                    color: Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Section :",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: //                 SizedBox(width: 40),
                              Container(
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    height: 40,
                                    // color: Colors.redAccent,
                                    alignment: Alignment.bottomCenter,
                                    //   DropdownButtonHideUnderline(
                                    color: Colors.white60,
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          // iconEnabledColor: Colors.redAccent,
                                          isExpanded: true,
                                          hint: Text("Select"),
                                          items: _dropA
                                              .map((String dropDownStringItem) {
                                            return DropdownMenuItem<String>(
                                              value: dropDownStringItem,
                                              child: Text(
                                                dropDownStringItem,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String newValueSelected) {
                                            setState(() {
                                              _currentValueSelectedA =
                                                  newValueSelected;
                                              _directory = Directory(_newPath +
                                                      _currentValueSelectedA +
                                                      '/')
                                                  .path;
                                              // print('directory = $_directory');
                                              var raw_lista =
                                                  Directory(_directory)
                                                      .listSync();
                                              // print(raw_lista);
                                              _dropB = [];
                                              for (int i = 0;
                                                  i < raw_lista.length;
                                                  i++) {
                                                _dropB.add((raw_lista[i].path)
                                                    .split('/')
                                                    .last);
                                              }
                                            });
                                            // print(_currentValueSelectedA);
                                          },
                                          value: _currentValueSelectedA,
                                          //validator: (value) => value == null ? 'field required' : null,
                                        ),
                                      ),
                                    )),
                                // ),
                                SizedBox(height: 22),
                                Container(
                                    height: 40,
                                    //                      alignment: Alignment.center,
                                    color: Colors.white60,
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text("Select"),
                                          items: _dropB
                                              .map((String dropDownStringItem) {
                                            return DropdownMenuItem<String>(
                                              value: dropDownStringItem,
                                              child: Text(
                                                dropDownStringItem,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String newValueSelected) {
                                            setState(() {
                                              _currentValueSelectedB =
                                                  newValueSelected;
                                              _directory = Directory(_newPath +
                                                      _currentValueSelectedA +
                                                      '/' +
                                                      _currentValueSelectedB +
                                                      '/')
                                                  .path;
                                              // print('directory = $_directory');
                                              var raw_lista =
                                                  Directory(_directory)
                                                      .listSync();
                                              // print(raw_lista);
                                              _dropC = [];
                                              for (int i = 0;
                                                  i < raw_lista.length;
                                                  i++) {
                                                _dropC.add((raw_lista[i].path)
                                                    .split('/')
                                                    .last);
                                              }
//    static String _displayStringForOption => _dropC;
                                            });
                                          },
                                          value: _currentValueSelectedB,
                                          //validator: (value) => value == null ? 'field required' : null,
                                        ),
                                      ),
                                    )),
                                SizedBox(height: 22),
                                Container(
                                      height: 40,
                                    color: Colors.white60,
                                    child: Container(
                                        // height: 40,
                                        // width: 70,
                                        //child:Expanded(
                                        /*
                              child: SimpleAutocompleteFormField<String>(
                              //  decoration: InputDecoration(labelText: 'Person',
                                   // border: OutlineInputBorder()
                               // ),
                             //   suggestionsHeight: 80.0,
                                itemBuilder: (context, person) => Padding(
                                   padding: EdgeInsets.all(0.0),
                                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                     Text(person, style: TextStyle(fontWeight: FontWeight.bold)),
                                    // Text(person)
                                   ]),
                                 ),
                                onSearch: (search) async => _dropC
                                    .where((person) =>
                                person.toLowerCase().contains(search.toLowerCase()))
                                    .toList(),
                                itemFromString: (string) {
                                  _sec =string;
                                  print(_sec);
                                  final matches = _dropC.where((person) => person.toLowerCase() == string.toLowerCase());
                                  return matches.isEmpty ? null : matches.first;
                                },
                            //    validator: (person) => person == null ? 'Invalid person.' : null,
                                onChanged: (String value) {
                                  _sec = value;
                                  print(_sec);
                                },
                                onSaved: (String value) {
                                  _sec = value;
                                  print(_sec);
                                },
                                  onFieldSubmitted:(String value) {
                                    _sec =  value;
                                    print(value);

                                  },
                              ),
*/
                                        /*
                              Autocomplete<String>(
                                optionsBuilder: (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return _dropC.where((String option) {
                                    return option.contains(textEditingValue.text.toString());
                                  });
                                },
                                onSelected: (String selection) {
                                  _sec = selection.toUpperCase();
                                  print(_sec);
                                },

                              )
                               */
                                        /*
                              TextFormField(

                                // cursorHeight: 28,
                                // textAlign: TextAlign.center,
                                //  controller: _mastTPController,
                                style: TextStyle(fontSize: 16),
                                enableSuggestions: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white70,
                                  errorStyle: TextStyle(height: 0),
                                  isDense: true,
                                  // expand:false,
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 18.0),
                                  // contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                                  hintText: "Enter",
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(4.0),
                                  //   borderSide: BorderSide(
                                  //     color: Colors.blueGrey,
                                  //     width: 1.0,
                                  //   ),
                                  // ),
                                  // labelText: 'Name',
                                ),
                                //                      maxLength: 10,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    scaff_function('Section is Required');
                                    return "";
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  _sec = value.toUpperCase();
                                  print(_sec);
                                },
                              ),

                               */
                                        //  ),
                                        // )

                                        child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
//                            alignment: Alignment.center,
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          hint: Text("Select"),
                                          items: _dropC
                                              .map((String dropDownStringItem) {
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
                                              _currentValueSelectedC =
                                                  newValueSelected;
                                              //   _sec = newValueSelected;
                                            });
                                          },
                                          value: _currentValueSelectedC,
                                          //validator: (value) => value == null ? 'field required' : null,
                                        ),
                                      ),
                                    )))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    // SizedBox(height: 10),
                    // SizedBox(height: 50),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: TextFormField(
                              // cursorHeight: 28,
                              // textAlign: TextAlign.center,
                              //  controller: _mastTPController,
                              style: TextStyle(fontSize: 16),
                              enableSuggestions: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                errorStyle: TextStyle(height: 0),
                                isDense: true,
                                // expand:false,
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 18.0),
                                // contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                                hintText: "Create Section",
                                // enabledBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(4.0),
                                //   borderSide: BorderSide(
                                //     color: Colors.blueGrey,
                                //     width: 1.0,
                                //   ),
                                // ),
                                // labelText: 'Name',
                              ),
                              //                      maxLength: 10,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  scaff_function('Section is Required');
                                  return "";
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _sec = value;
                                print(_sec);
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            child: ElevatedButton(
                              // textColor: Colors.white,
                              // color: Colors.blueAccent,
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF204C97),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 6),
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              child: Text(
                                'Create ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                _formKey.currentState.save();
                                if (_currentValueSelectedA != null) {
                                  if (_currentValueSelectedB != null) {
                                    if (_sec != "") {
                                      // setState(() {
                                      // filePath = _newPath +
                                      //     _currentValueSelectedA +
                                      //     '/' +
                                      //     _currentValueSelectedB +
                                      //     '/' +
                                      //     _currentValueSelectedC +
                                      //     '/';
                                      final filePath1 = Directory(_newPath +
                                          _currentValueSelectedA +
                                          '/' +
                                          _currentValueSelectedB +
                                          '/' +
                                          _sec +
                                          '/');
                                      // newPath = filePath;
                                      // myFilePath = filePath; // bluetooth chatpage
                                    //  Navigator.pushNamed(context, ViewPage.routeName);
                                      _createFolder() async {
                                        if (await filePath1.exists()) {
                                          // TODO:
                                          print("exist");
                                          _sec = "";
                                          scaff_function('Already Exist');
                                          _formKey.currentState.reset();
                                        } else {
                                          // TODO:
                                          print("not exist");
                                          filePath1.create();
                                          scaff_function('Created');
                                          _sec = "";
                                          _formKey.currentState.reset();
                                          // _currentValueSelectedC= null;
                                          // _currentValueSelectedB= null;
                                          // _currentValueSelectedA= null;
                                          /*
                                          var raw_lista =
                                          Directory(_directory)
                                              .listSync();
                                          // print(raw_lista);
                                          _dropC = [];
                                          for (int i = 0;
                                          i < raw_lista.length;
                                          i++) {
                                            _dropC.add((raw_lista[i].path)
                                                .split('/')
                                                .last);
                                          }
                                          */
                                        }
                                      }
                                      _createFolder();
                                      /*
                                      _chkFolder() async {
                                        if (await filePath1.exists()) {
                                          // TODO:
                                          print("exist");
                                          _sec = "";
                                          _formKey.currentState.reset();
                                          Navigator.pushNamed(
                                              context, ViewPage.routeName);
                                        } else {
                                          // TODO:
                                          _sec = "";
                                          print("not exist");
                                          scaff_function('File Not Exist !');
                                          _formKey.currentState.reset();
                                          //  filePath1.create();
                                        }
                                      }
*/
                                      // _chkFolder();
                                      //   if ( Directory(filePath1).exists() == true) {
                                      //     _formKey.currentState.reset();
                                      //     Navigator.pushNamed(context, ViewPage.routeName);
                                      //  }
                                      // else{
                                      //   print("bhag");
                                      // }
                                      // }
                                      //);
                                    } else {
                                      scaff_function('Enter Section');
                                    }
                                  } else {
                                    scaff_function('Division Raliways');
                                  }
                                } else {
                                  scaff_function('Select Raliways');
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
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
                        /*
                      Container(
                        width: 145,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.blue, width: 3,),
                          shape: BoxShape.rectangle,
                          color: Color(0xFF204C97),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "GPS",
                          style: TextStyle(
                            fontSize: 20,
                            color:Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                       */
                        SizedBox(
                          height: 16,
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
                                style: new TextStyle(fontSize: 20.0),
                              ),
                              new Radio(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: _handleRadioValueChange,
                              ),
                              new Text(
                                'External',
                                style: new TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            alignment: Alignment.center,
                            height: 60,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              // textColor: Colors.white,
                              // color: Colors.blueAccent,
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF204C97),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 6),
                                  textStyle: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                              child: Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                // print('radiovalue : $_radioValue');
                                // setState(() {
                                //   _formKey.currentState.save();
                                if (_currentValueSelectedA != null) {
                                  if (_currentValueSelectedB != null) {
                                    if (_currentValueSelectedC != null) {
                                      filePath = _newPath +
                                          _currentValueSelectedA +
                                          '/' +
                                          _currentValueSelectedB +
                                          '/' +
                                          _currentValueSelectedC +
                                          '/';
                                      //  _currentValueSelectedC +
                                      //  '/';
                                      newPath = filePath;
                                      // final filePath1 = _newPath +
                                      //     _currentValueSelectedA +
                                      //     '/' +
                                      //     _currentValueSelectedB +
                                      //     '/' +
                                      //     _currentValueSelectedC+
                                      // '/';
                                      // final newPath1 = Directory(filePath1);
                                      fileName = _currentValueSelectedA +
                                          '_' +
                                          _currentValueSelectedB +
                                          '_' +
                                          _currentValueSelectedC +
                                          '_';
                                      // ignore: unrelated_type_equality_checks

                                      _createFolder() async {
                                        // if (await newPath1.exists()) {
                                        //   // TODO:
                                        //   print("exist");
                                        //   _sec = "";
                                        //   _formKey.currentState.reset();
                                        // } else {
                                        //   // TODO:
                                        //   print("not exist");
                                        //   newPath1.create();
                                        //   _sec = "";
                                        //   _formKey.currentState.reset();
                                        // }
                                      } //   _currentValueSelectedC +

                                      //   '_';
                                      // _currentValueSelectedA = null;
                                      // _currentValueSelectedB = null;
                                      // _currentValueSelectedC = null;
                                      // });
                                      // print('filePath = $filePath');
                                      //  _createFolder();
                                      if (_radioValue == 0) {
                                        Navigator.pushNamed(
                                            context, SecondPage.routeName);
                                      } else {
                                        Navigator.pushNamed(
                                            context, BtMain.routeName);
                                      }
                                    } else {
                                      scaff_function('Enter Section');
                                    }
                                  } else {
                                    scaff_function('Select Division');
                                  }
                                } else {
                                  scaff_function('Select Raliways');
                                }
                              },
                            )),
                      ])),
                   SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    // color: Colors.yellow,
                    // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      // textColor: Colors.white,
                      // color: Colors.blueAccent,
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF204C97),
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: Text(
                        'Veiw Report',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _formKey.currentState.save();
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
                              final filePath1 = Directory(_newPath +
                                  _currentValueSelectedA +
                                  '/' +
                                  _currentValueSelectedB +
                                  '/' +
                                  _sec +
                                  '/');
                              // newPath = filePath;
                              // myFilePath = filePath; // bluetooth chatpage
                              Navigator.pushNamed(context, ViewPage.routeName);
                              /*
                              _chkFolder() async {
                                if (await filePath1.exists()) {
                                  // TODO:
                                  print("exist");
                                  _sec = "";
                                  _formKey.currentState.reset();
                                  Navigator.pushNamed(
                                      context, ViewPage.routeName);
                                } else {
                                  // TODO:
                                  _sec = "";
                                  print("not exist");
                                  scaff_function('File Not Exist !');
                                  _formKey.currentState.reset();
                                  //  filePath1.create();
                                }
                              }

                               */

                              // _chkFolder();
                              //   if ( Directory(filePath1).exists() == true) {
                              //     _formKey.currentState.reset();
                              //     Navigator.pushNamed(context, ViewPage.routeName);
                              //  }
                              // else{
                              //   print("bhag");
                              // }
                              // }
                              //);
                            } else {
                              scaff_function('Enter Section');
                            }
                          } else {
                            scaff_function('Division Raliways');
                          }
                        } else {
                          scaff_function('Select Raliways');
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
