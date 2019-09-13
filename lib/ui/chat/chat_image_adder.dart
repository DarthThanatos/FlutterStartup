import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatImageAdder extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>
      Column(
        children: <Widget>[
          SizedBox(height: 25),
          _header(),
          Divider(),
          _takePhotoBtn(),
          _pickFromGaleryBtn(),
          _selectUrlBtn(),
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
  
  
  Widget _takePhotoBtn() =>
    _iconTxtButton(Icons.photo_camera, "Zrób zdjęcie", _onTakePhoto);

  Widget _pickFromGaleryBtn() =>
      _iconTxtButton(Icons.burst_mode, "Wybierz z galerii", _onGoToGallery);

  Widget _selectUrlBtn() => 
      _iconTxtButton(Icons.link, "Wstaw url", _onInputUrl);

  Widget _cancelBtn(BuildContext context) =>
      FlatButton(child: Text("Anuluj"),
        onPressed: (){
          Navigator.pop(context);
        },
      );

  void _onTakePhoto(){
    print("Taking photo");
  }

  void _onGoToGallery(){
    print("Going to gallery");
  }

  void _onInputUrl() {
    print("Input url");
  }

  Widget _iconTxtButton(IconData iconData, String text, void Function() onPressed) =>
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10),
            FlatButton.icon(
              onPressed: onPressed,
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              icon: Icon(iconData),
              label: Text(text)
            ),
          ],
        );
}

class ChatImageAdderDialog{

    static Future<void> getImage(BuildContext context) =>
      showDialog<void>(
        barrierDismissible: true,
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
