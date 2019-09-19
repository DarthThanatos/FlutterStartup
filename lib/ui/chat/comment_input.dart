import 'package:flutter/material.dart';
import 'package:flutter_app/ui/chat/chat_image_adder.dart';

import 'contract.dart';
import 'image_grid_section.dart';
import 'related_comment_section.dart';

class CommentInput extends StatefulWidget {

  final ChatPresenter chatPresenter;

  CommentInput({
    Key key,
    @required this.chatPresenter
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => CommentInputState();

}

class CommentInputState extends State<CommentInput>{

  TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    _inputController.text = widget.chatPresenter.getMessageText();
    _inputController.addListener((){
      widget.chatPresenter.setMessageText(_inputController.text);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

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
            _sendMessageBtn()
          ],
        ),
        ImageGridSection(
            inputMode: true,
            chatPresenter: widget.chatPresenter
        )
      ]
    );
  }

  Widget _maybeRelatedCommentSection() =>
    widget.chatPresenter.getInputRelatedComment() == null
        ? Container()
        : RelatedCommentSection (
          inputMode: true,
          chatPresenter: widget.chatPresenter,
          relatedComment: widget.chatPresenter.getInputRelatedComment(),
        );

  Widget _commentEditText() =>
      Container(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
            child:
              TextFormField(
                controller: _inputController,
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

  Widget _sendMessageBtn() =>
      Row(
        children: <Widget>[
          _iconizedButton(Icons.send, widget.chatPresenter.sendMessage),
          SizedBox(width: 10)
        ],
      );

  void _onAddImage() async{
    String res = await BottomDialog.getImage(context, ChatImageAdder());
    if(res == null || res == "") return;
    widget.chatPresenter.addImage(res);
  }


  Widget _iconizedButton(IconData icon, void Function() onTap) =>
      InkWell(
        child: Icon(icon, size: 40,),
        onTap: onTap,
      );

}