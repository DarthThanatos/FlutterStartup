import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:share/share.dart';

import 'contract.dart';

class RootCommentButtonSection extends StatelessWidget {

  final BuiltChatItem rootItem;
  final ChatPresenter chatPresenter;

  RootCommentButtonSection({@required this.rootItem, @required this.chatPresenter});

  @override
  Widget build(BuildContext context) =>
      Row(
        children: <Widget>[
          SizedBox(width: 16),
          _saveButton(),
          _shareButton(),
          _reportButton()
        ],
      );


  Widget _saveButton() =>
      _iconTxtButton(Icons.favorite, "Obserwuj", _onSave);

  void _onSave(){
    print("Save clicked");
  }

  Widget _shareButton() =>
      _iconTxtButton(Icons.share, "Udostępnij", _onShare);

  void _onShare(){
    Share.share('https://example.com', subject: "Wyprawka");
  }

  Widget _reportButton() =>
      rootItem.reportedByMe
          ? _iconTxtButton(Icons.assistant_photo, "Zgłoszono", (){}, color: Colors.blue)
          : _iconTxtButton(Icons.assistant_photo, "Zgłoś", () => chatPresenter.reportComment(rootItem));

  Widget _iconTxtButton(IconData iconData, String text, void Function() onPressed, {Color color = Colors.grey}) =>
      FlatButton(
        onPressed: onPressed,
        color: Color(0x0F000000),
        padding: EdgeInsets.all(10.0),
        child: Column( // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Icon(iconData, color: color),
            Text(text, style: TextStyle(color: color))
          ],
        ),
      );
}