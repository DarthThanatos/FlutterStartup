import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RootCommentButtonSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) =>
      Row(
        children: <Widget>[
          SizedBox(width: 16),
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