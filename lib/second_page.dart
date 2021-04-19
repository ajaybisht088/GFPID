import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:db_test3/user_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'first_page.dart';
import 'login.dart';
import 'path_support.dart';

// String newPath = "";
// String fileName = "";

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

class LocationService {
  UserLocation _currentLocation = UserLocation(
    latitude: 0.00,
    longitude: 0.00,
    altitude: 0.00,
    speed: 0.00,
    accuracy: 0.00,
  );
  var location = Location();
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              altitude: locationData.altitude,
              speed: locationData.speed,
              accuracy: locationData.accuracy,
            ));
          }
        });
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      // var userLocation = await location.getExtras().getInt("satellites");
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
        altitude: userLocation.altitude,
        accuracy: userLocation.accuracy,
        speed: userLocation.speed,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }
}

class SecondPage extends StatefulWidget {
  SecondPage({Key key, this.title}) : super(key: key);

  // SecondPage({Key key, this.title, this.newPath}) : super(key: key);
  // final String newPath;
  static const String routeName = "/SecondPage";
  final String title;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  var hv_location = Location();
  String field1 = " ", field2 = " ", field3 = " ", field4 = " ", field5 = " ";
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffkey = new GlobalKey<ScaffoldState>();
  PickedFile Image1, Image2, Image3;
  File _Image1, _Image2, _Image3;
  var _line, _otherCl, _cl, _jumper, _otherJumper, _overl, _stgr, _imp, _height;
  var _signal, _otherSignal, _eng, _MastType, _remarks, _trd, _yard, _MastTP;
  int _fileNumCount1 = 0, _fileNumCount2 = 0, _fileNumCount3 = 0;
  final _mastTPController = TextEditingController();

  final picker = ImagePicker();
  int _jumperradioValue, _clradioValue, _lineradioValue, _overlradioValue;
  int _signalradioValue;
  String _imgOneLocation, _imgTwoLocation, _imgThreeLocation;
  String _lastMastTp;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _listofFiles();
    _listofFilesn();
    _getLastMastTp();
  }

  _getLastMastTp() async {
    // try {
    prefs = await SharedPreferences.getInstance();
    _lastMastTp = prefs.getString('lastMastTp');
    // print(_lastMastTp);
    hv_location.changeSettings(interval: 100);
  }

  var _mastTypeValues = ["None"];
  var _stgrTypeValues = ["None"];
  var _currentValueSelected;
  var _currentValueSelected1;
  var _directory;

  _listofFiles() {
    _directory = Directory(mastTypePath).path;
    // print('directory = $_directory');
    List raw_lista = Directory(_directory).listSync();
    // print(raw_lista);
    File file = new File(raw_lista[0].path);
    Future<String> futureContent = file.readAsString();
    // futureContent.then((c) {
    //   _mastTypeValues = c.split(',');
    //   print(_mastTypeValues);
    // });
    setState(() {
      futureContent.then((c) {
        _mastTypeValues = c.split(',');
        // print(_mastTypeValues);
      });
      _mastTypeValues;
    });
  }

  _listofFilesn() {
    _directory = Directory(stgrTypePath).path;
    // print('directory = $_directory');
    List raw_lista = Directory(_directory).listSync();
    // print(raw_lista);
    File file = new File(raw_lista[0].path);
    Future<String> futureContent = file.readAsString();
    // futureContent.then((c) {
    //   _mastTypeValues = c.split(',');
    //   print(_mastTypeValues);
    // });
    setState(() {
      futureContent.then((c) {
        _stgrTypeValues = c.split(',');
        // print(_stgrTypeValues);
      });
      _stgrTypeValues;
    });
  }

  String scaff_function(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(msg),
      backgroundColor: ((msg == "Data Saved") || (msg == "Photo Stored"))
          ? Colors.green
          : Colors.redAccent,
//      backgroundColor: Colors.green.shade500,
      duration: Duration(seconds: 1),
    ));
  }

  Future<bool> save_to_file(String data, String myfileName) async {
    // Directory directory;
    try {
      File saveFile = File(newPath + "$myfileName");
      if (await File(newPath + "$myfileName").exists()) {
        await saveFile.writeAsString(data, mode: FileMode.append, flush: false);
      } else {
        await saveFile.writeAsString(
            "Latitude, Longitude, Altitude, Speed, Accuracy, Satellites,"
            "Mast/TP, Mast Type, Line, Yard(value), CL,Other(CL),Jumper,"
            " Other(Jumper),Overl,STGR,IMP, Height,Signal,Other(Signal),"
            " ENG FEATURE, TRD FEATURE, REMARKS,Line Image 1,"
            " Line Image 2, LIneImage 3\n $data");
      }
      _lastMastTp = _MastTP;
      prefs.setString('lastMastTp', _lastMastTp);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> saveImage(int mastTpNumber, String folderName) async {
    // File Name = location/_MastTP-mastTpNumber-_fileNumCount.jpg
    try {
      final myImagePath = '${newPath}$folderName';
      if (!await Directory(myImagePath).exists()) {
        await Directory(myImagePath).create(recursive: true);
      }
      // print('newPath = ${newPath}$folderName');
      if (mastTpNumber == 1) {
        if (!await File(
                '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount1}.jpg')
            .exists()) {
          await _Image1.copy(
              '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount1}.jpg');
        } else {
          await _Image1.copy(
              '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount1++}.jpg');
        }
        setState(() {
          _imgOneLocation =
              '${_fileName()}/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount1}.jpg';
        });
        // print("_imgOneLocation = $_imgOneLocation");
      }
      if (mastTpNumber == 2) {
        if (!await File(
                '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount2}.jpg')
            .exists()) {
          await _Image2.copy(
              '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount2}.jpg');
        } else {
          await _Image2.copy(
              '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount2++}.jpg');
        }
        setState(() {
          _imgTwoLocation =
              '${_fileName()}/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount2}.jpg';
        });
        // print("_imgTwoLocation = $_imgTwoLocation");
      }
      if (mastTpNumber == 3) {
        if (!await File(
                '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount3}.jpg')
            .exists()) {
          await _Image3.copy(
              '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount3}.jpg');
        } else {
          await _Image3.copy(
              '$myImagePath/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount3++}.jpg');
        }
        setState(() {
          _imgThreeLocation =
              '${_fileName()}/${_mastTPController.text}-${mastTpNumber}-${_fileNumCount3++}.jpg';
        });
        // print("_imgThreeLocation = $_imgThreeLocation");
      }
      scaff_function("Photo Stored");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  _getImage(ImageSource imageSource, int imgNum) async {
    if (imgNum == 1) {
      Image1 = await picker.getImage(
        source: imageSource,
    //    maxHeight: 2048,
     //   maxWidth: 2048,
      );
      if (Image1 != null) {
        // print(Image1.path);
        setState(() {
          _Image1 = File(Image1.path);
        });
        await saveImage(1, _fileName());
      }
    }
    if (imgNum == 2) {
      Image2 = await picker.getImage(
        source: imageSource,
        maxHeight: 2048,
        maxWidth: 2048,
      );
      if (Image2 != null) {
        // print(Image2.path);
        setState(() {
          _Image2 = File(Image2.path);
        });
        await saveImage(2, _fileName());
      }
    }
    if (imgNum == 3) {
      Image3 = await picker.getImage(
        source: imageSource,
        maxHeight: 2048,
        maxWidth: 2048,
      );
      if (Image3 != null) {
        // print(Image3.path);
        setState(() {
          _Image3 = File(Image3.path);
        });
        await saveImage(3, _fileName());
      }
    }
  }

  String _fileName() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    // print('formatted = $formatted');
    return fileName + formatted;
  }

  String _latitude, _longitude, _altitude, _speed, _accuracy;

  _downloadFile() async {
    bool data_write_flag = false;
    if (_MastTP == _lastMastTp) {
      final bool action = await showAlert(context);
      // print("action = $action");
      if (!action) return false;
    }
    // var location_data = await hv_location.getLocation();
    //data_format = latitude,longitude,altitude,speed,accuracy,filed1,filed2,field3,filed4,field5
    data_write_flag = await save_to_file(
        "${_latitude}, ${_longitude}, ${_altitude}, ${_speed}, $_accuracy, 0,"
        "$_MastTP, $_currentValueSelected, $_line, $_yard, $_cl,$_otherCl,$_jumper,"
        "$_otherJumper,$_overl,$_currentValueSelected1,$_imp,$_height,$_signal,$_otherSignal,"
        "$_eng,$_trd,$_remarks, $_imgOneLocation, $_imgTwoLocation, "
        "$_imgThreeLocation\n",
        _fileName() + '.csv');
    if (data_write_flag) {
      // print("Data successfully written on File");
      return data_write_flag;
    } else {
      // print("Problem on writting data on File");
      return data_write_flag;
    }
  }

  void _handlelineRadioValueChange(int value) {
    setState(() {
      _lineradioValue = value;
      switch (_lineradioValue) {
        case 0:
          _line = "UP";
          break;
        case 1:
          _line = "DN";
          break;
        case 2:
          _line = "SL";
          break;
        case 3:
          _line = "Yard";
          break;
      }
    });
  }

  void _handleclRadioValueChange(int value) {
    setState(() {
      _clradioValue = value;
      switch (_clradioValue) {
        case 0:
          _cl = "S/CL";
          break;
        case 1:
          _cl = "D/CL";
          break;
        case 2:
          _cl = "T/CL";
          break;
        case 3:
          _cl = "Other";
          break;
      }
    });
  }

  void _handlejumperRadioValueChange(int value) {
    setState(() {
      _jumperradioValue = value;
      switch (_jumperradioValue) {
        case 0:
          _jumper = "G";
          break;
        case 1:
          _jumper = "C";
          break;
        case 2:
          _jumper = "F";
          break;
        case 3:
          _jumper = "Other";
          break;
      }
    });
  }

  void _handleoverlRadioValueChange(int value) {
    setState(() {
      _overlradioValue = value;
      switch (_overlradioValue) {
        case 0:
          _overl = "IOL";
          break;
        case 1:
          _overl = "UIOL";
          break;
      }
    });
  }

  void _handlesignalRadioValueChange(int value) {
    setState(() {
      _signalradioValue = value;
      switch (_signalradioValue) {
        case 0:
          _signal = "H";
          break;
        case 1:
          _signal = "A";
          break;
        case 2:
          _signal = "D";
          break;
        case 3:
          _signal = "Other";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    _longitude = userLocation != null
        ? '${roundDouble(userLocation.longitude, 6)}'
        : '00.0000';
    _latitude = userLocation != null
        ? '${roundDouble(userLocation.latitude, 6)}'
        : '00.0000';
    _altitude = userLocation != null
        ? '${roundDouble(userLocation.altitude, 1)}'
        : '00.0';
    _speed = userLocation != null
        ? '${roundDouble(userLocation.speed * 3.6, 1)}'
        : '00.0';
    _accuracy = userLocation != null
        ? '${roundDouble(userLocation.accuracy - (userLocation.accuracy * 0.2), 1)}'
        : '00.0';
    return Scaffold(
      appBar: AppBar(
        title: Text('Internal Gps'),
        key: _scaffkey,
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
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //      SizedBox(height: 70),
                //     Divider(),
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF204C97),
                        width: 3,
                      ),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.white70,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 56,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                //  color: Colors.white,
                                ),
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.location_searching,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "LONGITUDE : ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF204C97),
                                        fontFamily: 'MyriadPro',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 3,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                            Text(
                                          _longitude,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        )))
                              ],
                            ),
                          ),

                          //  Divider(),
                          Container(
                            height: 46,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                ),
                            // padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.location_searching,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "LATITUDE : ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF204C97),
                                        fontFamily: 'MyriadPro',
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 3,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                            Text(
                                          _latitude,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        )))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          //    Divider(),
                          Container(
                            //   width: 160,
                            height: 60,
                            decoration: BoxDecoration(
                                //  color: Colors.white,
                                ),
                            alignment: Alignment.center,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      //   width: 160,
                                      height: 60,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          //          color: Colors.white,
                                          ),
                                      // padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Altitude",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF204C97),
                                                fontFamily: 'MyriadPro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                                Text(
                                              _altitude,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      //   width: 160,
                                      height: 76,
                                      alignment: Alignment.center,
                                      // padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Speed",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF204C97),
                                                fontFamily: 'MyriadPro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                                Text(
                                              _speed,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      //   width: 160,
                                      height: 60,
                                      alignment: Alignment.center,
                                      // padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Accuracy",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xFF204C97),
                                                fontFamily: 'MyriadPro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                                Text(
                                              _accuracy,
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          /*
                          Container(
                            //   width: 160,
                            height: 60,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    //   width: 160,
                                    height: 66,
                                    alignment: Alignment.center,
                                    // padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Satellite",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF204C97),
                                              fontFamily: 'MyriadPro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                          Text(
                                            (userLocation) != null
                                                ? '0.0'
                                                : '0.0',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                           */
                        ])),
                Divider(),

                Container(
                  height: 36,
                  // alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Text(
                            "Mast/TP  ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF204C97),
                              fontFamily: 'MyriadPro',
                              //  fontWeight: FontWeight.bold,
                            ),
                            //   textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          //   height: 40,
                          // width: 70,
                          //child:Expanded(
                          child: TextFormField(
                            // cursorHeight: 28,
                            // textAlign: TextAlign.center,
                            controller: _mastTPController,
                            style: TextStyle(fontSize: 16),

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white70,
                              errorStyle: TextStyle(height: 0),
                              isDense: true,
                              // expand:false,
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 2.0),
                              // contentPadding: new EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                              hintText: "   Enter",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 1.0,
                                ),
                              ),
                              // labelText: 'Name',
                            ),
                            //                      maxLength: 10,
                            validator: (String value) {
                              if (value.isEmpty) {
                                scaff_function('Mast/TP is Required');
                                return "";
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _MastTP = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
//                Divider(),
                Container(
                  // alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Container(
                          child: Text(
                            "Mast Type",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF204C97),
                              fontFamily: 'MyriadPro',
                              //  fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 3,
                          child: Container(
                            height: 36,
                            //    color: Colors.white60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 1,
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              color: Colors.white70,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  elevation: 2,
                                  hint: Text("Select"),
                                  dropdownColor: Colors.white,
                                  iconDisabledColor: Colors.white,
                                  style: TextStyle(color: Colors.lightBlue),
                                  items: _mastTypeValues
                                      .map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Text(
                                        dropDownStringItem,
                                        style: TextStyle(
                                          fontSize: 19,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String newValueSelected) {
                                    setState(() {
                                      _currentValueSelected = newValueSelected;
                                    });
                                  },
                                  value: _currentValueSelected,
                                  //validator: (value) => value == null ? 'field required' : null,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          color: Color(0xFF204C97),
                        ),
                        //   height: 24,
                        //   width: 40,
                        child: Text(
                          'Line',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 0,
                        toggleable: true,
                        groupValue: _lineradioValue,
                        onChanged: _handlelineRadioValueChange,
                      ),
                      Text(
                        'UP',
                        style: new TextStyle(fontSize: 12.0),
                        // )]
                      ),
                      //  ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 1,
                        toggleable: true,
                        groupValue: _lineradioValue,
                        onChanged: _handlelineRadioValueChange,
                      ),
                      new Text(
                        'DN',
                        style: new TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 2,
                        toggleable: true,
                        groupValue: _lineradioValue,
                        onChanged: _handlelineRadioValueChange,
                      ),
                      new Text(
                        'SL',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
//                      materialTapTargetSize:2
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 3,
                        toggleable: true,
                        groupValue: _lineradioValue,
                        onChanged: _handlelineRadioValueChange,
                      ),
                      Container(
//                        height: 26,
                        width: 60,
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Yard",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            enabled: ((_lineradioValue) != 3 ? false : true),
                            isDense: true,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 2.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          ),
                          onSaved: (String value) {
                            _yard = ((_lineradioValue) != 3 ? "N/A" : value);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          color: Color(0xFF204C97),
                        ),
                        // height: 24,
                        //     width: 50,
                        // child: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        child: Text(
                          'Jumper',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                        //   ],
                        // ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 0,
                        toggleable: true,
                        groupValue: _jumperradioValue,
                        onChanged: _handlejumperRadioValueChange,
                      ),
                      new Text(
                        'G',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 1,
                        toggleable: true,
                        groupValue: _jumperradioValue,
                        onChanged: _handlejumperRadioValueChange,
                      ),
                      new Text(
                        'C',
                        style: new TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 2,
                        toggleable: true,
                        groupValue: _jumperradioValue,
                        onChanged: _handlejumperRadioValueChange,
                      ),
                      new Text(
                        'F',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 3,
                        toggleable: true,
                        groupValue: _jumperradioValue,
                        onChanged: _handlejumperRadioValueChange,
                      ),
                      Container(
//                        height: 26,
                        width: 60,
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Others",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            enabled: ((_jumperradioValue) != 3 ? false : true),
                            isDense: true,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 2.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          ),
                          onSaved: (String value) {
                            _otherJumper =
                                ((_jumperradioValue) != 3 ? "N/A" : value);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        // margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          color: Color(0xFF204C97),
                        ),
                        //   height: 24,
                        //    width: 60,
                        child: Text(
                          'Signal',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 0,
                        toggleable: true,
                        groupValue: _signalradioValue,
                        onChanged: _handlesignalRadioValueChange,
                      ),
                      new Text(
                        'H',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 1,
                        toggleable: true,
                        groupValue: _signalradioValue,
                        onChanged: _handlesignalRadioValueChange,
                      ),
                      new Text(
                        'A',
                        style: new TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 2,
                        toggleable: true,
                        groupValue: _signalradioValue,
                        onChanged: _handlesignalRadioValueChange,
                      ),
                      new Text(
                        'D',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 3,
                        toggleable: true,
                        groupValue: _signalradioValue,
                        onChanged: _handlesignalRadioValueChange,
                      ),
                      // new Text(
                      //   'Other ',
                      //   style: new TextStyle(fontSize: 16.0),
                      // ),

                      Container(
//                        height: 26,
                        width: 60,
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Others",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            enabled: ((_signalradioValue) != 3 ? false : true),
                            isDense: true,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 2.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          ),
                          onSaved: (String value) {
                            _otherSignal =
                                ((_signalradioValue) != 3 ? "N/A" : value);
//                            _otherSignal = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // alignment: Alignment.center,
                        // margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          color: Color(0xFF204C97),
                        ),
                        //      height: 24,
                        //      width: 25,
                        child: Text(
                          'CL',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 0,
                        toggleable: true,
                        groupValue: _clradioValue,
                        onChanged: _handleclRadioValueChange,
                      ),
                      // Divider(),
                      new Text(
                        'S/CL',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 1,
                        toggleable: true,
                        groupValue: _clradioValue,
                        onChanged: _handleclRadioValueChange,
                      ),
                      // Divider(),
                      new Text(
                        'D/CL',
                        style: new TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //   splashRadius:4,
                        value: 2,
                        toggleable: true,
                        groupValue: _clradioValue,
                        onChanged: _handleclRadioValueChange,
                      ),
                      // Divider(),
                      new Text(
                        'T/CL',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //    splashRadius:1,
                        value: 3,
                        toggleable: true,
                        groupValue: _clradioValue,
                        onChanged: _handleclRadioValueChange,
                      ),
                      Container(
//                        height: 26,
                        width: 60,
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Others",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            enabled: ((_clradioValue) != 3 ? false : true),
                            isDense: true,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 2.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          ),
                          onSaved: (String value) {
                            _otherCl = ((_clradioValue) != 3 ? "N/A" : value);
//                            _otherSignal = value;
                          },
                        ),
                      )
                    ],
                  ),
                ), //
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Container(
                        // margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          shape: BoxShape.rectangle,
                          color: Color(0xFF204C97),
                        ),
                        //   height: 24,
                        //  width: 50,
                        child: Text(
                          'Overl',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                        // ],
                        // ),
                      ),
                      new Radio(
                        value: 0,
                        toggleable: true,
                        groupValue: _overlradioValue,
                        onChanged: _handleoverlRadioValueChange,
                      ),
                      new Text(
                        'IOL',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        value: 1,
                        toggleable: true,
                        groupValue: _overlradioValue,
                        onChanged: _handleoverlRadioValueChange,
                      ),
                      new Text(
                        'UIOL',
                        style: new TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ])),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
                  //            alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 26,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))
                              //color: Colors.white70,
                              ),
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                elevation: 2,
                                hint: Text("STGR"),
                                dropdownColor: Colors.white,
                                iconDisabledColor: Colors.white,
                                style: TextStyle(color: Colors.lightBlue),
                                items: _stgrTypeValues
                                    .map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(
                                      dropDownStringItem,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String newValueSelected) {
                                  setState(() {
                                    _currentValueSelected1 = newValueSelected;
                                  });
                                },
                                value: _currentValueSelected1,

                                //validator: (value) => value == null ? 'field required' : null,
                              ),
                            ),
                          ),

                          /*
                        child: TextFormField(
                          //             textAlign: TextAlign.center ,

                          decoration: InputDecoration(
                            labelText: "STGR",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 2.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1.0)),
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 2),
                            ),
                          ),
                          onSaved: (String value) {
                            _stgr = value;
                          },
                        ),

                         */
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 26,
                          width: 90,
                          alignment: Alignment.center,
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: " IMP",
                              labelStyle: TextStyle(fontSize: 12),
                              errorStyle: TextStyle(height: 0),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 2.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 2),
                              ),
                            ),
                            onSaved: (String value) {
                              _imp = value;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 26,
                          width: 90,
                          alignment: Alignment.center,
                          child: TextFormField(
                            //             textAlign: TextAlign.center ,

                            decoration: InputDecoration(
                              labelText: " HEIGHT",
                              labelStyle: TextStyle(fontSize: 12),
                              errorStyle: TextStyle(height: 0),
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 1.0, horizontal: 2.0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.0),
                                borderSide: BorderSide(
                                  color: Colors.blueGrey,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 2),
                              ),
                            ),
                            onSaved: (String value) {
                              _height = value;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                ),

                SizedBox(
                  height: 18,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 4,
                            child: Text(
                              "ENG-Feature :",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Flexible(
                              flex: 5,
                              child: Container(
                                //    height: 28,
                                //    width: 160,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white70,
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 2.0),
                                    // expand:false,
                                    //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                    errorStyle: TextStyle(height: 0),
                                    // contentPadding: new EdgeInsets.symmetric(
                                    //     vertical: 1.0, horizontal: 2.0),
                                    //  hintText: "Enter",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onSaved: (String value) {
                                    _eng = value;
                                  },
                                ),
                              ))
                        ])),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 4,
                            child: Container(
                              child: Text(
                                "Trd-Feature   :",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 5,
                              child: Container(
                                //      height: 28,
                                //      width: 160,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white70,
                                    errorStyle: TextStyle(height: 0),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 2.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onSaved: (String value) {
                                    _trd = value;
                                  },
                                ),
                              )),
                        ])),
                Divider(
                  thickness: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                              flex: 4,
                              child: Container(
                                child: Text(
                                  "Remarks        :",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              )),
                          Flexible(
                              flex: 5,
                              child: Container(
                                //       height: 28,
                                //       width: 160,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white70,
                                    errorStyle: TextStyle(height: 0),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 2.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Colors.blueGrey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onSaved: (String value) {
                                    _remarks = value;
                                  },
                                ),
                              ))
                        ])),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 20),
                Container(
                  //   width: 160,
                  height: 80,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex:1,
                        child:Container(
                        //   width: 160,
                        height: 80,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                             // alignment: Alignment.centerLeft,
                              child: Text(
                                "Location",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              //                  child: //Text("${roundDouble(userLocation?.latitude, 6)}",
//                              Text("00000",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
                              child: FlatButton.icon(
                                icon: ((_Image1 != null)
                                    ? (Icon(Icons.image))
                                    : (Icon(Icons.camera_alt))),
                                color: Colors.grey,
                                label: ((_Image1 != null)
                                    ? (Text('Pic1',
                                        style: TextStyle(fontSize: 12)))
                                    : (Text("Click",
                                        style: TextStyle(fontSize: 12)))),
                                onPressed: () {
                                  _getImage(ImageSource.camera, 1);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),),
                      VerticalDivider(
                        thickness: 2,
                      ),
                      Flexible(
                        flex: 1,
                        child:
                      Container(
                        //   width: 160,
                        height: 80,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                      //        alignment: Alignment.centerLeft,
                              child: Text(
                                "OHE",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: FlatButton.icon(
                                icon: ((_Image2 != null)
                                    ? (Icon(Icons.image))
                                    : (Icon(Icons.camera_alt))),
                                color: Colors.grey,
                                label: ((_Image2 != null)
                                    ? (Text('Pic2',
                                        style: TextStyle(fontSize: 12)))
                                    : (Text("Click",
                                        style: TextStyle(fontSize: 12)))),
                                onPressed: () {
                                  _getImage(ImageSource.camera, 2);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                      VerticalDivider(
                        thickness: 2,
                      ),
                      Flexible(
                        flex: 1,
                        child:
                      Container(
                        //   width: 160,
                        height: 80,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                    //          alignment: Alignment.centerLeft,
                              child: Text(
                                "Other",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: FlatButton.icon(
                                icon: ((_Image3 != null)
                                    ? (Icon(Icons.image))
                                    : (Icon(Icons.camera_alt))),
                                color: Colors.grey,
                                label: ((_Image3 != null)
                                    ? (Text('Pic3',
                                        style: TextStyle(fontSize: 12)))
                                    : (Text("Click",
                                        style: TextStyle(fontSize: 12)))),
                                onPressed: () {
                                  _getImage(ImageSource.camera, 3);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),)
                    ],
                  ),
                ),
                SizedBox(height: 14),
                Divider(
                  thickness: 2,
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  //   height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        // height: 60,
                        alignment: Alignment.center,
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          icon: Icon(Icons.save_outlined),
                          // textColor: Colors.white,
                          backgroundColor: Color(0xFF204C97),
                          label: Text(
                            ' Save ',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              // print(" not validated");
                              return;
                            }
                            _formKey.currentState.save();
                            if (await _downloadFile()) {
                              setState(() {
                                scaff_function("Data Saved");
                                _formKey.currentState.reset();
                                _Image1 = null;
                                Image1 = null;
                                _Image2 = null;
                                Image2 = null;
                                _Image3 = null;
                                Image3 = null;
                                _mastTPController.text = "";
                                _lineradioValue = null;
                                _line = null;
                                _jumper = null;
                                _jumperradioValue = null;
                                _signalradioValue = null;
                                _currentValueSelected= null;
                                _currentValueSelected1= null;
                                _signal = null;
                                _cl = null;
                                _clradioValue = null;
                                _overl = null;
                                _overlradioValue = null;
                              });
                            } else {
                              scaff_function("Data not Saved!!!");
                            }
                          },
                        ),
                      ),
                      Container(
                        // height: 80,
                        alignment: Alignment.center,
                        child: FloatingActionButton.extended(
                          heroTag: null,
                          icon: Icon(Icons.insert_drive_file),
                          backgroundColor: Color(0xFF204C97),
                          // textColor: Colors.white,
                          // backgroundColor: Color(0xFF204C97),
                          label: Text(
                            'Submit',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            _showPartialKey(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPartialKey(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, FirstPage.routeName, (_) => false);
        // Navigator.of(context).pushNamed('/HomePage');
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert : "),
      // content: Text("Work in Progress."),
      content: Text("Are you Sure"),
      // encodedAndroidId,
      //onTap: () {
      // Clipboard.setData(new ClipboardData(text: encodedAndroidId));
      // you can show toast to the user, like "Copied"
      // },
      // ),
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

  showAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Duplicate MastTp'),
          content: Text("Are You Sure Want To Proceed ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
