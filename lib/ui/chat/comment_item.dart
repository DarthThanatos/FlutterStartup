import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/util/date-util.dart';

import 'image_section.dart';

class CommentItemPage extends StatelessWidget{

  final BuiltChatItem chatItem;

  CommentItemPage({Key key, @required this.chatItem}): super(key: key);

  @override
  Widget build(BuildContext context) =>
    Column(children: <Widget>[
      _authorRow(),
      SizedBox(height: 10),
      _commentText(),
      SizedBox(height: 10),
      _maybeImgSection(),
      _commentBottomRow(),
      Divider()]
    );

  Widget _authorRow() =>
    Row(
      children: <Widget>[
        _authorImg(),
        SizedBox(width: 10),
        _authorName(),
        _time()
      ],
    );

  Widget _authorImg() =>
      Container(
        width: 20,
        height: 20,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                image: NetworkImage(chatItem.user.avatarUrl),
                fit: BoxFit.fill
            )
        ),
      );

  Widget _authorName() =>
      Text(
        chatItem.user.userName,
        style: TextStyle(fontSize: 16)
      );

  Widget _commentText() =>
      Text(
        chatItem.text,
        style: TextStyle(fontSize: 22),
      );

  Widget _commentBottomRow() =>
      Row(
        children: <Widget>[
          SizedBox(width: 10),
          _iconizedButton(Icons.undo, "Odpowiedź", _onAnswer),
          SizedBox(width: 10),
          _iconizedButton(Icons.assistant_photo, "Zgłoś", _onReport),
          _expandedLike()
        ],
      );

  Widget _expandedLike() =>
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_iconizedButton(Icons.thumb_up, "", _onLike)],
        ),
      );

  void _onAnswer(){
    print("Answering on comment with id: ${chatItem.chatItemId}");
  }
  
  void _onReport(){
    print("Reporting comment with id: ${chatItem.chatItemId}");
  }

  void _onLike(){
    print("Liking comment with id: ${chatItem.chatItemId}");

  }

  Widget _time() =>
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              DateUtils.getPrettyTimeDifferenceFromStringDate(chatItem.creationTime),
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      );

  Widget _iconizedButton(IconData icon, String text, void Function() onPressed) =>
      FlatButton.icon(
        icon: Icon(icon), //`Icon` to display
        label: Text(
            text,
            style: TextStyle(fontSize: 15),
        ), //`Text` to display
        onPressed: onPressed
      );

  Widget _maybeImgSection() {
    final fileInfo = chatItem.fileInfo;
    return fileInfo == null ? Container() : ImageSection(fileInfo: fileInfo);
  }

}