import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatImageAdder extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>
      Column(
        children: <Widget>[
          SizedBox(height: 25),
          _header(),
          Divider(),
          _takePhotoBtn(context),
          _pickFromGaleryBtn(context),
          _selectUrlBtn(context),
          Divider(),
          _cancelBtn(context)
        ],
      );

  Widget _header() =>
      Container(
          height: 75, 
          child: 
            Text(
                "Załącz obrazek", 
                style: 
                  TextStyle(
                      fontSize: 25, 
                      color: Colors.black, 
                      decoration: TextDecoration.none
                  )
            )
      );
  
  
  Widget _takePhotoBtn(BuildContext context) =>
    _iconTxtButton(Icons.photo_camera, "Zrób zdjęcie", _onTakePhoto, context);

  Widget _pickFromGaleryBtn(BuildContext context) =>
      _iconTxtButton(Icons.burst_mode, "Wybierz z galerii", _onGoToGallery, context);

  Widget _selectUrlBtn(BuildContext context) =>
      _iconTxtButton(Icons.link, "Wstaw url", _onInputUrl, context);

  Widget _cancelBtn(BuildContext context) =>
      FlatButton(child: Text("Anuluj"),
        onPressed: (){
          Navigator.pop(context, "");
        },
      );

  void _onTakePhoto(BuildContext context) async {
    print("Taking photo");
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    Navigator.pop(context, image != null ? image.path: "");
  }

  void _onGoToGallery(BuildContext context) async {
    print("Going to gallery");
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Navigator.pop(context, image != null ? image.path: "");
  }

  void _onInputUrl(BuildContext context) {
    print("Input url");
    Navigator.pop(context, "inputurl");
  }

  Widget _iconTxtButton(IconData iconData, String text, void Function(BuildContext) onPressed, BuildContext context) =>
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10),
            FlatButton.icon(
              onPressed: () => onPressed(context),
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              icon: Icon(iconData),
              label: Text(text)
            ),
          ],
        );
}

class ChatImageAdderDialog{

    static Future<String> getImage(BuildContext context) =>
      showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: ChatImageAdder()
                ),
              )
            ],
          );
        },
      );

}
