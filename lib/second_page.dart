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
      print("widget.nwPath = ${newPath}");
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
      print('newPath = ${newPath}$folderName');
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
        print("_imgOneLocation = $_imgOneLocation");
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
        print("_imgTwoLocation = $_imgTwoLocation");
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
        print("_imgThreeLocation = $_imgThreeLocation");
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
        maxHeight: 200,
        maxWidth: 200,
      );
      if (Image1 != null) {
        print(Image1.path);
        setState(() {
          _Image1 = File(Image1.path);
        });
        await saveImage(1, _fileName());
      }
    }
    if (imgNum == 2) {
      Image2 = await picker.getImage(
        source: imageSource,
        maxHeight: 200,
        maxWidth: 200,
      );
      if (Image2 != null) {
        print(Image2.path);
        setState(() {
          _Image2 = File(Image2.path);
        });
        await saveImage(2, _fileName());
      }
    }
    if (imgNum == 3) {
      Image3 = await picker.getImage(
        source: imageSource,
        maxHeight: 200,
        maxWidth: 200,
      );
      if (Image3 != null) {
        print(Image3.path);
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
    print('formatted = $formatted');
    return fileName + formatted;
  }

  _downloadFile() async {
    // var hv_location = Location();
    var location_data = await hv_location.getLocation();
    //data_format = latitude,longitude,altitude,speed,accuracy,filed1,filed2,field3,filed4,field5
    bool data_write_flag = await save_to_file(
        "${location_data.latitude.toString()},"
        " ${location_data.longitude.toString()}, ${location_data.altitude.toString()},"
        "${location_data.speed.toString()}, ${location_data.accuracy.toString()}, 0,"
        "$_MastTP, $_MastType, $_line, $_yard, $_cl,$_otherCl,$_jumper,"
        "$_otherJumper,$_overl,$_stgr,$_imp,$_height,$_signal,$_otherSignal,"
        "$_eng,$_trd,$_remarks, $_imgOneLocation, $_imgTwoLocation, "
        "$_imgThreeLocation\n",
        _fileName() + '.csv');
    if (data_write_flag) {
      print("Data successfully written on File");
      return data_write_flag;
    } else {
      print("Problem on writting data on File");
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
  // TODO: implement widget

  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
        key: _scaffkey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //      SizedBox(height: 70),
                Container(
                  //   width: 160,
                  height: 80,
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: Container(
                            height: 80,
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Latitude ",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                    width: 100,
                                    height: 27,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1,
                                      ),
                                      shape: BoxShape.rectangle,
                                      color: Colors.black12,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                        Text((userLocation) != null
                                            ? '${userLocation.latitude}'
                                            : '000000'))
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            //   width: 160,
                            height: 80,
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  // width: 160,
                                  // height: 80,
                                  // decoration:  BoxDecoration(
                                  //   border: Border.all(color: Colors.blue,width: 3,),
                                  //   shape: BoxShape.rectangle,
                                  //   color: Colors.white10,),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Longitude ",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    shape: BoxShape.rectangle,
                                    color: Colors.black12,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                      Text((userLocation) != null
                                          ? '${roundDouble(userLocation.longitude, 7)}'
                                          : '000000'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            //   width: 160,
                            height: 80,
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  // width: 160,
                                  // height: 80,
                                  // decoration:  BoxDecoration(
                                  //   border: Border.all(color: Colors.blue,width: 3,),
                                  //   shape: BoxShape.rectangle,
                                  //   color: Colors.white10,),

                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Altitude ",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    shape: BoxShape.rectangle,
                                    color: Colors.black12,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                      Text((userLocation) != null
                                          ? '${roundDouble(userLocation.altitude, 4)}'
                                          : '000000'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  //   width: 160,
                  height: 80,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          //   width: 160,
                          height: 80,
                          alignment: Alignment.centerLeft,
                          // padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Satellite ",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 27,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  shape: BoxShape.rectangle,
                                  color: Colors.black12,
                                ),
                                alignment: Alignment.centerLeft,
                                child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                    Text(
                                  "000000",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
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
                          height: 80,
                          // decoration: BoxDecoration(
                          // border: Border.all(color: Colors.blue, width: 3,),
                          // shape: BoxShape.rectangle,
                          // color: Colors.white10,),
                          alignment: Alignment.centerLeft,
                          // padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                // width: 160,
                                // height: 80,
                                // decoration:  BoxDecoration(
                                //   border: Border.all(color: Colors.blue,width: 3,),
                                //   shape: BoxShape.rectangle,
                                //   color: Colors.white10,),

                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Speed ",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 27,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  shape: BoxShape.rectangle,
                                  color: Colors.black12,
                                ),
                                alignment: Alignment.centerLeft,
                                child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                    Text((userLocation) != null
                                        ? '${roundDouble(userLocation.speed, 2)}'
                                        : '000000'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          //   width: 160,
                          height: 80,
                          // decoration: BoxDecoration(
                          // border: Border.all(color: Colors.blue, width: 3,),
                          // shape: BoxShape.rectangle,
                          // color: Colors.white10,),
                          alignment: Alignment.centerLeft,
                          // padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                // width: 160,
                                // height: 80,
                                // decoration:  BoxDecoration(
                                //   border: Border.all(color: Colors.blue,width: 3,),
                                //   shape: BoxShape.rectangle,
                                //   color: Colors.white10,),

                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Accuracy ",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 27,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  shape: BoxShape.rectangle,
                                  color: Colors.black12,
                                ),
                                alignment: Alignment.centerLeft,
                                child: //Text("${roundDouble(userLocation?.latitude, 6)}",
                                    Text((userLocation) != null
                                        ? '${roundDouble(userLocation.accuracy, 3)}'
                                        : '000000'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Divider(),
                Container(
                  // alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Mast/TP  ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        height: 24,
                        width: 70,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _mastTPController,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            isDense: true,
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
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
                      Text(
                        "  Mast Type  ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Container(
                        height: 24,
                        width: 70,
                        child: TextFormField(
                          textAlign: TextAlign.center,

                          decoration: InputDecoration(
                            isDense: true,
                            errorStyle: TextStyle(height: 0),
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                                width: 1.0,
                              ),
                            ),
                          ),
                          //   border: OutlineInputBorder(
                          //       borderSide: BorderSide(color: Colors.red, width: 12.0,style: BorderStyle.solid),
                          //       borderRadius: BorderRadius.circular(0.0)
                          //             ),
                          // labelText: 'Name',
                          // ),
                          //                      maxLength: 10,
                          validator: (String value) {
                            if (value.isEmpty) {
                              scaff_function('MastType is Required');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _MastType = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Divider(),
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
                          color: Colors.blue,
                        ),
                        height: 24,
                        width: 40,
                        // child: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        child: Text(
                          'Line',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                        //   ],
                        // ),
                      ),
                      Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 0,
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
                        groupValue: _lineradioValue,
                        onChanged: _handlelineRadioValueChange,
                      ),
                      // new Text(
                      //   'Yard  ',
                      //   style: new TextStyle(fontSize: 12.0),
                      // ),
                      Container(
                        height: 24,
                        width: 60,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Yard",
                            labelStyle: TextStyle(fontSize: 12),
                            errorStyle: TextStyle(height: 0),
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
                          //                      maxLength: 10,
                          validator: (String value) {
                            if ((value.isEmpty && _lineradioValue == 3) ||
                                (_lineradioValue == null)) {
                              scaff_function('Please select LINE ');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _yard = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                          color: Colors.blue,
                        ),
                        height: 24,
                        width: 25,
                        // child: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        child: Text(
                          'CL',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                        //   ],
                        // ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 0,
                        groupValue: _clradioValue,
                        onChanged: _handleclRadioValueChange,
                      ),
                      // Divider(),
                      new Text(
                        'S/CL',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      Divider(),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 1,
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
                        groupValue: _clradioValue,
                        onChanged: _handleclRadioValueChange,
                      ),
                      // new Text(
                      //   'Other',
                      //   style: new TextStyle(fontSize: 12.0),
                      // ),
                      Container(
                        height: 24,
                        width: 60,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Others",
                            labelStyle: TextStyle(fontSize: 10),
                            //   isDense: true,
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            errorStyle: TextStyle(height: 0),
                            // contentPadding: new EdgeInsets.symmetric(
                            //     vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
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
                          //                       maxLength: 10,
                          validator: (String value) {
                            if ((value.isEmpty && _clradioValue == 3) ||
                                (_clradioValue == null)) {
                              scaff_function('Please select CL');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _otherCl = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                          color: Colors.blue,
                        ),
                        height: 24,
                        width: 50,
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
                        groupValue: _jumperradioValue,
                        onChanged: _handlejumperRadioValueChange,
                      ),
                      // new Text(
                      //   'Other',
                      //   style: new TextStyle(fontSize: 16.0),
                      // ),
                      Container(
                        height: 24,
                        width: 60,
                        alignment: Alignment.center,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Others",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            isDense: true,
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            // contentPadding: new EdgeInsets.symmetric(
                            //     vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
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
                          //                      maxLength: 10,
                          validator: (String value) {
                            if ((value.isEmpty && _jumperradioValue == 3) ||
                                (_jumperradioValue == null)) {
                              scaff_function('Please Choose Jumper');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _otherJumper = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                          color: Colors.blue,
                        ),
                        height: 24,
                        width: 50,
                        // child: Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
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
                        groupValue: _overlradioValue,
                        onChanged: _handleoverlRadioValueChange,
                      ),
                      new Text(
                        'IOL',
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      new Radio(
                        value: 1,
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  //            alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Text(
                      //   " STGR ",
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
                      Container(
                        height: 24,
                        width: 80,
                        alignment: Alignment.center,
                        child: TextFormField(
                          //             textAlign: TextAlign.center ,

                          decoration: InputDecoration(
                            labelText: "STGR",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            isDense: true,
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            // contentPadding: new EdgeInsets.symmetric(
                            //     vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
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
                          //                      maxLength: 10,
                          validator: (String value) {
                            if (value.isEmpty) {
                              scaff_function('Please enter STGR');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _stgr = value;
                          },
                        ),
                      ),
                      // Text(
                      //   "IMP",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //   ),
                      //   textAlign: TextAlign.start,
                      // ),
                      Divider(),
                      Container(
                        height: 24,
                        width: 80,
                        child: TextFormField(
                          textAlign: TextAlign.center,

                          decoration: InputDecoration(
                            labelText: "IMP",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            isDense: true,
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            // contentPadding: new EdgeInsets.symmetric(
                            //     vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
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
                          //   border: OutlineInputBorder(
                          //       borderSide: BorderSide(color: Colors.red, width: 12.0,style: BorderStyle.solid),
                          //       borderRadius: BorderRadius.circular(0.0)
                          //             ),
                          // labelText: 'Name',
                          // ),
                          //                      maxLength: 10,
                          validator: (String value) {
                            if (value.isEmpty) {
                              scaff_function('Please enter IMP');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _imp = value;
                          },
                        ),
                      ),
                      Divider(),
                      // Text(
                      //   "Height",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //   ),
                      //   textAlign: TextAlign.start,
                      // ),
                      Container(
                        height: 24,
                        width: 80,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "HEIGHT",
                            labelStyle: TextStyle(fontSize: 10),
                            isDense: true,
                            errorStyle: TextStyle(height: 0),
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            // contentPadding: new EdgeInsets.symmetric(
                            //     vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
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
                          //   border: OutlineInputBorder(
                          //       borderSide: BorderSide(color: Colors.red, width: 12.0,style: BorderStyle.solid),
                          //       borderRadius: BorderRadius.circular(0.0)
                          //             ),
                          // labelText: 'Name',
                          // ),
                          //                      maxLength: 10,
                          validator: (String value) {
                            if (value.isEmpty) {
                              scaff_function('Please Enter Height');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _height = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                          color: Colors.blue,
                        ),
                        height: 24,
                        width: 60,
                        child: Text(
                          'Signal',
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                      new Radio(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: 0,
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
                        groupValue: _signalradioValue,
                        onChanged: _handlesignalRadioValueChange,
                      ),
                      // new Text(
                      //   'Other ',
                      //   style: new TextStyle(fontSize: 16.0),
                      // ),
                      Container(
                        height: 24,
                        width: 60,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Others",
                            labelStyle: TextStyle(fontSize: 10),
                            errorStyle: TextStyle(height: 0),
                            isDense: true,
                            // expand:false,
                            //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            // contentPadding: new EdgeInsets.symmetric(
                            //     vertical: 1.0, horizontal: 2.0),
                            //  hintText: "Enter",
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
                          //                      maxLength: 10,
                          validator: (String value) {
                            if ((value.isEmpty && _lineradioValue == 3) ||
                                (_lineradioValue == null)) {
                              scaff_function('Choose Signal is ');
                              return "";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _otherSignal = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                //jbsdkjbk
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "ENG-Feature : ",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            height: 28,
                            width: 160,
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                // expand:false,
                                //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                errorStyle: TextStyle(height: 0),
                                // contentPadding: new EdgeInsets.symmetric(
                                //     vertical: 1.0, horizontal: 2.0),
                                //  hintText: "Enter",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              //                      maxLength: 10,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "";
                                  //scaff_function('ENG-Feature is Required');
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _eng = value;
                              },
                            ),
                          )
                        ])),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Trd-Feature   :",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            height: 28,
                            width: 160,
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                errorStyle: TextStyle(height: 0),
                                // expand:false,
                                //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                // contentPadding: new EdgeInsets.symmetric(
                                //     vertical: 1.0, horizontal: 2.0),
                                //  hintText: "Enter",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              //                      maxLength: 10,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  scaff_function("TRD is Required");
                                  return "";
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _trd = value;
                              },
                            ),
                          )
                        ])),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Remarks        :",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            height: 28,
                            width: 160,
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                errorStyle: TextStyle(height: 0),
                                // expand:false,
                                //             contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                // contentPadding: new EdgeInsets.symmetric(
                                //     vertical: 1.0, horizontal: 2.0),
                                //  hintText: "Enter",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(1.0),
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              //                      maxLength: 10,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  scaff_function("Remarks is Required");
                                  return "";
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                _remarks = value;
                              },
                            ),
                          )
                        ])),
                SizedBox(height: 20),
                Container(
                  //   width: 160,
                  height: 80,
                  // decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blue, width: 3,),
                  // shape: BoxShape.rectangle,
                  // color: Colors.white10,),
                  alignment: Alignment.center,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          //   width: 160,
                          height: 80,
                          // decoration: BoxDecoration(
                          // border: Border.all(color: Colors.blue, width: 3,),
                          // shape: BoxShape.rectangle,
                          // color: Colors.white10,),
                          alignment: Alignment.center,
                          // padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                // width: 160,
                                // height: 80,
                                // decoration:  BoxDecoration(
                                //   border: Border.all(color: Colors.blue,width: 3,),
                                //   shape: BoxShape.rectangle,
                                //   color: Colors.white10,),

                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Line1",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                  //   width: 160,
                                  //   height: 80,
                                  //                       decoration:  BoxDecoration(
                                  //                            border: Border.all(color: Colors.grey,width: 1,),
                                  //                            shape: BoxShape.rectangle,
                                  //                           color: Colors.black12,),
                                  alignment: Alignment.center,
                                  //                  child: //Text("${roundDouble(userLocation?.latitude, 6)}",
//                              Text("00000",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
                                  child: FlatButton(
                                    //                             textColor: Colors.white,
//
                                    color: Colors.grey,

                                    child: ((_Image1 != null)
                                        ? (Text('Image1',
                                            style: TextStyle(fontSize: 12)))
                                        : (Text("Click1",
                                            style: TextStyle(fontSize: 12)))),

                                    onPressed: () {
                                      _getImage(ImageSource.camera, 1);
//                                print(nameController.text);
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          //   width: 160,
                          height: 80,
                          // decoration: BoxDecoration(
                          // border: Border.all(color: Colors.blue, width: 3,),
                          // shape: BoxShape.rectangle,
                          // color: Colors.white10,),
                          alignment: Alignment.center,
                          // padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                // width: 160,
                                // height: 80,
                                // decoration:  BoxDecoration(
                                //   border: Border.all(color: Colors.blue,width: 3,),
                                //   shape: BoxShape.rectangle,
                                //   color: Colors.white10,),

                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Line2",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                  //   width: 160,
                                  //   height: 80,
                                  //                       decoration:  BoxDecoration(
                                  //                            border: Border.all(color: Colors.grey,width: 1,),
                                  //                            shape: BoxShape.rectangle,
                                  //                           color: Colors.black12,),
                                  alignment: Alignment.center,
                                  //                  child: //Text("${roundDouble(userLocation?.latitude, 6)}",
//                              Text("00000",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
                                  child: FlatButton(
                                    //                             textColor: Colors.white,
//
                                    color: Colors.grey,

                                    child: ((_Image2 != null)
                                        ? (Text('Image2',
                                            style: TextStyle(fontSize: 12)))
                                        : (Text("Click2",
                                            style: TextStyle(fontSize: 12)))),

                                    onPressed: () {
                                      _getImage(ImageSource.camera, 2);
//                                print(nameController.text);
                                    },
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          //   width: 160,
                          height: 80,
                          // decoration: BoxDecoration(
                          // border: Border.all(color: Colors.blue, width: 3,),
                          // shape: BoxShape.rectangle,
                          // color: Colors.white10,),
                          alignment: Alignment.center,
                          // padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                // width: 160,
                                // height: 80,
                                // decoration:  BoxDecoration(
                                //   border: Border.all(color: Colors.blue,width: 3,),
                                //   shape: BoxShape.rectangle,
                                //   color: Colors.white10,),

                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Line3",
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                  //   width: 160,
                                  //   height: 80,
                                  //                       decoration:  BoxDecoration(
                                  //                            border: Border.all(color: Colors.grey,width: 1,),
                                  //                            shape: BoxShape.rectangle,
                                  //                           color: Colors.black12,),
                                  alignment: Alignment.center,
                                  //                  child: //Text("${roundDouble(userLocation?.latitude, 6)}",
//                              Text("00000",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,),
                                  child: FlatButton(
                                    //                             textColor: Colors.white,
//
                                    color: Colors.grey,

                                    child: ((_Image3 != null)
                                        ? (Text('Image3',
                                            style: TextStyle(fontSize: 12)))
                                        : (Text("Click3",
                                            style: TextStyle(fontSize: 12)))),

                                    onPressed: () {
                                      _getImage(ImageSource.camera, 3);
//                                print(nameController.text);
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  //   height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.blueAccent,
                          child: Text(
                            'SAVE',
                            style: TextStyle(fontSize: 30),
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState.validate()) {
                              print(" not validated");
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
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
