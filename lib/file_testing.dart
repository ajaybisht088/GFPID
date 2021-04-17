import 'package:db_test3/first_page.dart';
import 'package:flutter/rendering.dart';
import 'package:share/share.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class ViewPage extends StatefulWidget {
  ViewPage({Key key, this.title}) : super(key: key);
  static const String routeName = "/ViewPage";
  final String title;

  @override
  _ViewPageState createState() => _ViewPageState();
}

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; //Data of the user
  ListItem(this.data); //Constructor to assign the data
}

class _ViewPageState extends State<ViewPage> {
  String text = '';
  String subject = '';
  List<ListItem<String>> list;
  List<String> selectedItems = [];
  List<String> selectedItemsPath = [];
  bool isEnabled = false;

  enableViewButton() {
    setState(() {
      isEnabled = true;
    });
  }

  disableViewButton() {
    setState(() {
      isEnabled = false;
    });
  }

  sampleFunction() async {
    // print('Clicked');
    await OpenFile.open(filePath + selectedItems[0]);
  }

  @override
  void initState() {
    super.initState();
    populateData();
  }

  void populateData() {
    var _directory = Directory(filePath).path;
    // print('directory = $_directory');
    var raw_lista = Directory(_directory).listSync();
    // print(raw_lista);
    list = [];
    for (int i = 0; i < raw_lista.length; i++) {
      list.add(ListItem<String>((raw_lista[i].path).split('/').last));
    }
    // print(list);
    // list = [];
    // for (int i = 0; i < 10; i++)
    //   list.add(ListItem<String>("item $i"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF204C97),
        title: Text("Reports"),
        actions: [
          IconButton(
              onPressed: isEnabled ? () => sampleFunction() : null,
              icon: Icon(Icons.table_view)),
          IconButton(
              onPressed: text.isEmpty && selectedItems.isEmpty
                  ? null : () => _onShare(context),
              icon: Icon(Icons.share)),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: _getListItemTile,
              ),
            ),
            // SizedBox(
            //   height: 200,
            // ),
            // Container(
            //   alignment: Alignment.bottomCenter,
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: <Widget>[
            //         RaisedButton.icon(
            //           onPressed: isEnabled ? () => sampleFunction() : null,
            //           // color: Colors.pinkAccent,
            //           icon: Icon(Icons.table_view),
            //           color: Color(0xFF204C97),
            //           textColor: Colors.white,
            //           padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            //           label: Text('View'),
            //         ),
            //         RaisedButton(
            //           onPressed: text.isEmpty && selectedItems.isEmpty
            //               ? null
            //               : () => _onShare(context),
            //           color: Colors.green,
            //           textColor: Colors.white,
            //           padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            //           child: Text('Share'),
            //         ),
            //       ],
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // )
          ],
        ),
      ),
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (list.any((item) => item.isSelected)) {
          setState(() {
            list[index].isSelected = !list[index].isSelected;
          });
        }
        if (list[index].isSelected == true) {
          selectedItems.add(list[index].data);
          selectedItemsPath.add(filePath + list[index].data);
        } else {
          selectedItems.remove(list[index].data);
          selectedItemsPath.remove(filePath + list[index].data);
        }
        // print(selectedItems);
        if (selectedItems.length == 1) {
          enableViewButton();
        } else {
          disableViewButton();
        }
      },
      onLongPress: () {
        setState(() {
          list[index].isSelected = true;
          selectedItems.add(list[index].data);
          selectedItemsPath.add(filePath + list[index].data);
          // print(selectedItems);
          if (selectedItems.length == 1) {
            enableViewButton();
          } else {
            disableViewButton();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        color: list[index].isSelected ? Colors.blueAccent[100] : Colors.white,
        child: ListTile(
          title: Text(list[index].data),
        ),
      ),
    );
  }

  _onDeleteImage(int position) {
    setState(() {
      selectedItemsPath.removeAt(position);
    });
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;

    if (selectedItemsPath.isNotEmpty) {
      await Share.shareFiles(selectedItemsPath,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("text");
  }
}
