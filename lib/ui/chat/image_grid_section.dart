import 'dart:io';

import 'package:flutter/material.dart';

import 'image_viewer.dart';

const double FILE_TILE_HEIGHT = 125;
const double FILE_TILE_WIDTH = 50;

class ImageGridSection extends StatelessWidget {

  final Set<String> photosPaths;
  final ImageInputListener listener; // contract: if listener is null, then we are in the nested comment section, otherwise we are in the comment input section
  
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
                  children: photosPaths.map((path)=>_imageTile(context, path)).toList()
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
    if(photosPaths.length == 0) return 0;
    if(photosPaths.length > 3)
      return photosPaths.length / 3 * (FILE_TILE_HEIGHT + 15);
    return FILE_TILE_HEIGHT + 15;
  }

  Widget _imageTile(BuildContext context, String path) {
    final image = _buildImage(context, path);
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

  Widget _buildImage(BuildContext context, String path) =>
      _imageContainer(
        context,
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
        ), path
      );

  Widget _imageContainer(BuildContext context, Widget child, String path) =>
      listener == null
        ? InkWell(
          child: child,
          onTap: () => _onDisplayImage(context, path)
        )
        : Container(
          child: child
        );

  void _onDisplayImage(BuildContext context, String path){
    Navigator.push(context, MaterialPageRoute(builder: (_) => ImageViewer(imgPath: path)));
  }
  
  void _removeImg(String path){
    listener.onImageRemoved(path);
  }

}

abstract class ImageInputListener{
  void onImageRemoved(String path);
}