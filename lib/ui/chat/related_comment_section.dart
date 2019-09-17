import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/util/size_util.dart';

import 'comment_item.dart';

class RelatedCommentSection extends StatelessWidget{

  final BuiltChatItem relatedComment;
  final RespondToCommentListener relatedCommentListener;
  final bool inputMode;

  RelatedCommentSection(
      {Key key,
        @required this.relatedComment,
        @required this.relatedCommentListener,
        @required this.inputMode
      }): super(key: key);

  @override
  Widget build(BuildContext context) =>
      Container(
        width: SizeUtils.screenHeight(context),
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
        onTap: _onScrollToComment,
      );

  Widget _removeCommentButton() =>
      InkWell(
        child: Icon(Icons.remove_circle),
        onTap: _onRemoveComment,
      );

  void _onScrollToComment(){
    relatedCommentListener.onGoToComment(relatedComment);
  }

  void _onRemoveComment() {
    relatedCommentListener.onRemoveRelatedComment();
  }

}
