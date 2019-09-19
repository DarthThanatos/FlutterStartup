import 'package:flutter/material.dart';
import 'package:flutter_app/util/size_util.dart';

class ProgressBar {
  
  OverlayEntry _progressOverlayEntry;
  
  void show(BuildContext context){
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry);
  }
  
  void hide(){
    if(_progressOverlayEntry != null){
      _progressOverlayEntry.remove();
      _progressOverlayEntry = null;
    }
  }
  
  OverlayEntry _createdProgressEntry(BuildContext context) =>
      OverlayEntry(
          builder: (BuildContext context) =>
              Positioned(
                top: screenHeight(context) / 2,
                left: screenWidth(context) / 2,
                child: CircularProgressIndicator(),
              )
      );
  
}