import 'package:flutter/material.dart';
import 'package:flutter_app/ui/chat/chat_image_adder.dart';

class CommentInput extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => CommentInputState();

}

class CommentInputState extends State<CommentInput> {

  @override
  Widget build(BuildContext context){
    return Container(
      child:
      Row(
        children: <Widget>[
          _commentEditText(),
          _addImageBtn(),
          _addCommentBtn()
        ],
      ),
    );
  }

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
    await ChatImageAdderDialog.getImage(context);
  }

  void _onAddComment(){
    print("Adding comment");
  }

  Widget _iconizedButton(IconData icon, void Function() onTap) =>
      InkWell(
        child: Icon(icon, size: 40,),
        onTap: onTap,
      );

}