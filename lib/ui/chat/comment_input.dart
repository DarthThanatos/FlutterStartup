import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/ui/chat/chat_image_adder.dart';

import 'comment_item.dart';
import 'image_grid_section.dart';
import 'related_comment_section.dart';

class CommentInput extends StatefulWidget {

  final BuiltChatItem maybeRelatedComment;
  final RespondToCommentListener respondToCommentListener;

  CommentInput({Key key, this.maybeRelatedComment, @required this.respondToCommentListener}): super(key: key);

  @override
  State<StatefulWidget> createState() => CommentInputState();

}

class CommentInputState extends State<CommentInput> implements ImageInputListener{

  Set<String> _photosPaths = Set();

  @override
  Widget build(BuildContext context){
    return Column(
      children:
      [
        _maybeRelatedCommentSection(),
        Row(
          children: <Widget>[
            _commentEditText(),
            _addImageBtn(),
            _addCommentBtn()
          ],
        ),
        ImageGridSection(listener: this, photosPaths: _photosPaths)
      ]
    );
  }

  Widget _maybeRelatedCommentSection() =>
    widget.maybeRelatedComment == null
        ? Container()
        : RelatedCommentSection (
          relatedComment: widget.maybeRelatedComment,
          inputMode: true,
          relatedCommentListener: widget.respondToCommentListener
        );

  Widget _commentEditText() =>
      Container(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
            child:
              TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Napisz komentarz'
                ),
              ),
          ),
      );

  Widget _addImageBtn() =>
      Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _iconizedButton(Icons.image, _onAddImage),
              SizedBox(width: 10)
            ],
          )
      );

  Widget _addCommentBtn() =>
      Row(
        children: <Widget>[
          _iconizedButton(Icons.send, _onAddComment),
          SizedBox(width: 10)
        ],
      );

  void _onAddImage() async{
    print("Adding image");
    String res = await BottomDialog.getImage(context, ChatImageAdder());
    print("Resulting image path: $res");
    if(res == null || res == "") return;
    final newSet = Set.of(_photosPaths)..add(res);
    setState(() {
      _photosPaths = newSet;
    });
  }

  void _onAddComment(){
    print("Adding comment");
  }

  Widget _iconizedButton(IconData icon, void Function() onTap) =>
      InkWell(
        child: Icon(icon, size: 40,),
        onTap: onTap,
      );

  @override
  void onImageRemoved(String path) {
    final newSet = _photosPaths.difference(Set.from([path]));
    setState(() {
      _photosPaths = newSet;
    });
  }

}
