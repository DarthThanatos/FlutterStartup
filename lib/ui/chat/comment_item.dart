import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';

const COMMENT_ITEM_PAGE_HEIGHT = 250.0;

class CommentItemPage {

  static BuiltChatItem chatItem;

  static List<Widget> getViews(BuiltChatItem chatItem) {
    CommentItemPage.chatItem = chatItem;
    return [
      _authorRow(),
      SizedBox(height: 10),
      _commentText(),
      SizedBox(height: 10),
      _commentBottomRow(),
      Divider()
    ];
  }

  static Widget _authorRow() =>
    Row(
      children: <Widget>[
        _authorImg(),
        SizedBox(width: 10),
        _authorName(),
        _time()
      ],
    );

  static Widget _authorImg() =>
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

  static Widget _authorName() =>
      Text(
        chatItem.user.userName,
        style: TextStyle(fontSize: 16)
      );

  static Widget _commentText() =>
      Text(
        chatItem.text,
        style: TextStyle(fontSize: 22),
      );

  static Widget _commentBottomRow() =>
      Row(
        children: <Widget>[
          SizedBox(width: 10),
          _iconizedButton(Icons.undo, "Odpowiedź", _onAnswer),
          SizedBox(width: 10),
          _iconizedButton(Icons.assistant_photo, "Zgłoś", _onReport),
          _expandedLike()
        ],
      );

  static Widget _expandedLike() =>
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_iconizedButton(Icons.thumb_up, "", _onLike)],
        ),
      );

  static void _onAnswer(){
    print("Answering on comment with id: ${chatItem.chatItemId}");
  }
  
  static void _onReport(){
    print("Reporting comment with id: ${chatItem.chatItemId}");
  }

  static void _onLike(){
    print("Liking comment with id: ${chatItem.chatItemId}");

  }

  static Widget _time() =>
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "16 min",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      );

  static Widget _iconizedButton(IconData icon, String text, void Function() onPressed) =>
      FlatButton.icon(
        icon: Icon(icon), //`Icon` to display
        label: Text(
            text,
            style: TextStyle(fontSize: 15),
        ), //`Text` to display
        onPressed: onPressed
      );

}