import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/util/size_util.dart';

class ImageViewer extends StatelessWidget{
  
  final String imgPath;
  
  ImageViewer({@required this.imgPath});
  
  @override
  Widget build(BuildContext context) =>
          Material(
            color: Colors.transparent,
            child:
              Container(
                width: SizeUtils.screenWidth(context),
                height: SizeUtils.screenHeight(context),
                child:

                Column(
                    children: <Widget>[
                      _goBackBtn(context),
                      _imageSection()
                ]
              ),
            )
          );

  Widget _goBackBtn(BuildContext context) =>
      Column(
        children: <Widget>[
          SizedBox(height: 30),
          Row(
              children:[
                SizedBox(width: 10),
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child:
                      Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 40
                      )
                )
              ]
          ),
        ],
      );

  Widget _imageSection() =>
      Padding(
        padding: const EdgeInsets.only(left: 50.0, right: 50, bottom: 50, top: 20),
        child: imgPath.startsWith("http")
            ? Image.network(
                imgPath,
                fit: BoxFit.scaleDown
            )
            : Image.file(
                File(imgPath),
                fit: BoxFit.scaleDown
            ),
      );

}