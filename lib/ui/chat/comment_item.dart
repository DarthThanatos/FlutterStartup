import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';

class CommentItemPage extends StatelessWidget{

  final BuiltChatItem chatItem;

  CommentItemPage({Key key, @required this.chatItem}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  Widget _authorRow() =>
    Row(
      children: <Widget>[
        _authorImg(),
        SizedBox(width: 10),
        _authorName()
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
}