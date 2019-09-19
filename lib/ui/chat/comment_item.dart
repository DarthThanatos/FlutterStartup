import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/util/date-util.dart';

import 'contract.dart';
import 'image_grid_section.dart';
import 'related_comment_section.dart';


class CommentItemPage extends StatelessWidget{

  final BuiltChatItem chatItem;
  final ChatPresenter chatPresenter;

  CommentItemPage({Key key, @required this.chatItem, @required this.chatPresenter}): super(key: key);

  @override
  Widget build(BuildContext context) =>
    Column(
      children: <Widget>[
        _authorRow(),
        SizedBox(height: 10),
        _maybeRelatedCommentSection(),
        SizedBox(height: 10),
        _commentText(),
        _imgsGrid(),
        _commentBottomRow(),
        Divider()
      ],
    );

  Widget _maybeRelatedCommentSection() =>
      chatItem.parentId == null
          ? Container()
          : RelatedCommentSection (
            inputMode: false,
            chatPresenter: chatPresenter,
            relatedComment: chatPresenter.getRelatedOf(chatItem),
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
        _maybeResponseButton(),
         chatItem.reportedByMe
             ? _iconizedButton(Icons.assistant_photo, "Zgłoszono", (){},  color: Colors.blue)
             : _iconizedButton(Icons.assistant_photo, "Zgłoś", () => chatPresenter.reportComment(chatItem)),
        _expandedLike()
      ],
    );

  Widget _maybeResponseButton() =>
    chatItem.text != ""
        ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [_iconizedButton(Icons.undo, "Odpowiedź", () => chatPresenter.setInputRelatedComment(chatItem)), SizedBox(width: 20)]
        )
        : Container();

  Widget _expandedLike() =>
    Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          chatItem.likedByMe
            ? _iconizedButton(Icons.thumb_up, chatItem.amountOfLikes.toString(), (){}, color: Colors.blue)
            : _iconizedButton(Icons.thumb_up, chatItem.amountOfLikes.toString(), () => chatPresenter.likeComment(chatItem))
        ],
      ),
    );

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

  Widget _iconizedButton(IconData icon, String text, void Function() onPressed, {Color color = Colors.grey}) =>
      InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: color, size: 15),
              SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(fontSize: 12, color: color),
              ), //`Text` to display
            ],
          ),
          onTap: onPressed
      );

  Widget _imgsGrid() =>
    ImageGridSection(chatPresenter: chatPresenter, inputMode: false, chatItem: chatItem);



}