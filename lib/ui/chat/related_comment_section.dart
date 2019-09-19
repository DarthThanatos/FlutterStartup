import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/util/size_util.dart';

import 'contract.dart';

class RelatedCommentSection extends StatelessWidget{

  final bool inputMode;
  final ChatPresenter chatPresenter;
  final BuiltChatItem relatedComment;

  RelatedCommentSection(
      {Key key,
        @required this.chatPresenter,
        @required this.inputMode,
        @required this.relatedComment
      }): super(key: key);

  @override
  Widget build(BuildContext context) =>
      Container(
        width: screenHeight(context),
        child:
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 25),
            child:
              Container(
                decoration: _relatedDecoration(),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _authorName(),
                        _actionButton()
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(relatedComment.text),
                    ),
                    Container(height: 5)
                  ],
                ),
              ),
          ),
      );

  BoxDecoration _relatedDecoration() =>
      BoxDecoration(
          color: Color(0x0F000000),
          border:
          Border(
              left:
              BorderSide(width: 3, color: Colors.blue)
          )
      );


  Widget _authorName() =>
      Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "${relatedComment.user.userName}:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          )
      );

  Widget _actionButton() {
    final btn = inputMode ? _removeCommentButton() : _scrollToCommentButton();
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all()
        ),
        child: btn,
      ),
    );
  }

  Widget _scrollToCommentButton() =>
      InkWell(
        child: Icon(Icons.arrow_upward),
        onTap: () => chatPresenter.goToComment(relatedComment),
      );

  Widget _removeCommentButton() =>
      InkWell(
        child: Icon(Icons.remove_circle),
        onTap: () => chatPresenter.setInputRelatedComment(null),
      );

}
