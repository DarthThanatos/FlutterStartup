import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UrlPicker extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => UrlPickerState();

}

class UrlPickerState extends State<UrlPicker>{

  TextEditingController _controller;
  String _errorMsg = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _header(context),
              Divider(),
              SizedBox(height: 50),
              _urlInputSection(),
              SizedBox(height: 65),
              _submitBtn(context),
              Container(height: 125)
            ],
          ),
        ),
      );

  Widget _header(BuildContext context) =>
      Row(
        children: [
          _returnButton(context),
          _title()
        ]
      );

  Widget _title() =>
    Expanded(
     child:
       Text(
           "Wstaw URL",
           textAlign: TextAlign.center,
           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)
       )
    );

  Widget _returnButton(BuildContext context) =>
      InkWell(
        child: Icon(Icons.chevron_left),
        onTap: () => _onCancelClicked(context),
      );

  Widget _urlInputSection() =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _urlSmall(),
          SizedBox(height: 5),
          _urlTextInput()
        ],
      );

  Widget _urlSmall() =>
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child:
            Text(
              "URL",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 15, color: Colors.grey)
            ),
        ),
        Text(
          _errorMsg,
          style: TextStyle(color: Colors.red),
        )
      ],
    );

  Widget _urlTextInput() =>
      TextFormField(
          controller: _controller,
          decoration:
            InputDecoration(
                labelText: 'Napisz tekst urla',
                border: OutlineInputBorder()
            )
      );

  Widget _submitBtn(BuildContext context) =>
      Container(
        width: 175,
        height: 50,
        child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            color: Colors.blue,
            onPressed: () => _submit(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Załącz",
                style:
                  TextStyle(
                      fontSize: 22,
                      color: Colors.white
                  )
              ),
            )
        ),
      );

  void _onCancelClicked(BuildContext context){
    Navigator.pop(context);
  }

  void _submit(BuildContext context) async {
    String preResult = _controller.value.text;
    String result = preResult.startsWith("http") ? preResult : "http://$preResult";

    head(result).then(
        (response){
          if(response.statusCode == 200){
            Navigator.pop(context, result);
          }
          else{
            setState(() {
              _errorMsg = "Invalid url";
            });
          }
        }
    ).catchError((e){
      setState(() {
        _errorMsg = e.message;
      });
    });
  }

}