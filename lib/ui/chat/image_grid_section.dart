import 'dart:io';

import 'package:flutter/material.dart';

const double FILE_TILE_HEIGHT = 125;
const double FILE_TILE_WIDTH = 50;

class ImageGridSection extends StatelessWidget {

  final Set<String> photosPaths;
  final ImageInputListener listener;
  
  ImageGridSection({Key key, @required this.photosPaths, this.listener}): super(key: key);
  
  @override
  Widget build(BuildContext context) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child:
      Container(
        height: listener != null ? _getWidgetHeight(): _getTotalHeight(),
        child:
              GridView.count(
                  physics: listener == null ? NeverScrollableScrollPhysics(): AlwaysScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                  children: photosPaths.map((path)=>_imageTile(path)).toList()
              ),
          )
    );

  double _getWidgetHeight(){
    if(photosPaths.length == 0) return 0;
    if(photosPaths.length < 4)
      return FILE_TILE_HEIGHT;
    return 200;
  }

  double _getTotalHeight() {
    return photosPaths.length / 3 * (FILE_TILE_HEIGHT + 15);
  }

  Widget _imageTile(String path) {
    final image = _buildImage(path);
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: listener != null ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image,
          Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _removeImg(path);
                },
                child: Icon(Icons.remove_circle),
              ),
              Expanded(child: Container(),)
            ],
          )
        ],
      ) : image
    );
  }

  Widget _buildImage(String path) =>
      path.startsWith("http")
      ? Image.network(
        path,
        fit: BoxFit.scaleDown,
        width: FILE_TILE_WIDTH,
        height: FILE_TILE_HEIGHT,
      )
      : Image.file(
          File(path),
          fit: BoxFit.scaleDown,
          width: FILE_TILE_WIDTH,
          height: FILE_TILE_HEIGHT
      );

  void _removeImg(String path){
    listener.onImageRemoved(path);
  }

}

abstract class ImageInputListener{
  void onImageRemoved(String path);
}