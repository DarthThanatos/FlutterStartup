
import 'package:flutter/material.dart';
import 'package:flutter_app/api/model/built_file_info.dart';

class ImageSection extends StatelessWidget{

  final BuiltFileInfo fileInfo;

  ImageSection({Key key, @required this.fileInfo}): super(key: key);

  @override
  Widget build(BuildContext context) =>
      Padding(
        padding: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _imageDisplayer()
          ],
        ))
    ;


  Widget _imageDisplayer() =>
    Container(
      color: Color(0x0F000000),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              width: 150,
              child:
                Image.network(fileInfo.url)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    fileInfo.filename,
                    style: TextStyle(fontSize: 20),
                ),
                Text(
                  fileInfo.sizeDesc,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );


      
}