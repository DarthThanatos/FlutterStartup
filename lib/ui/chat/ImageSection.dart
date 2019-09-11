
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_file_info.dart';

class ImageSection extends StatelessWidget{

  final BuiltFileInfo fileInfo;

  ImageSection({Key key, @required this.fileInfo}): super(key: key);

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _imageDisplayer(),
            SizedBox(height: 25),
            _buttonsSection()
          ],
        ))
    ;


  Widget _imageDisplayer() =>
    Container(
      color: Color(0x0F000000),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              width: 150,
              child:
                Image.network(fileInfo.url)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    fileInfo.filename,
                    style: TextStyle(fontSize: 20),
                ),
                Text(
                  fileInfo.sizeDesc,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );

  Widget _buttonsSection() =>
      Row(
        children: <Widget>[
          _saveButton(),
          _shareButton(),
          _notifyButton()
        ],
      );

  Widget _saveButton() =>
    _iconTxtButton(Icons.favorite, "Zapisz", _onSave);
  
  void _onSave(){
    print("Save clicked");
  }
  
  Widget _shareButton() =>
    _iconTxtButton(Icons.share, "Udostępnij", _onShare);
  
  void _onShare(){
    print("Share clicked");
  }
  
  Widget _notifyButton() =>
    _iconTxtButton(Icons.assistant_photo, "Zgłoś", _onNotify);

  void _onNotify(){
    print("Notify clicked");
  }

  Widget _iconTxtButton(IconData iconData, String text, void Function() onPressed) =>
      FlatButton(
        onPressed: onPressed,
        color: Color(0x0F000000),
        padding: EdgeInsets.all(10.0),
        child: Column( // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Icon(iconData),
            Text(text)
          ],
        ),
      );
      
}