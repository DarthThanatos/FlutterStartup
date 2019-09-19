import 'package:flutter/material.dart';

class ChatScrollNavigator{

  Map<int, double> _commentViewsHeights = Map();

  ScrollController _nestedController;
  ScrollController _outerController;

  void initState(){
    _outerController = ScrollController();
    _nestedController = ScrollController();
  }

  void dispose(){
    _outerController.dispose();
    _nestedController.dispose();
  }

  void _logCommentViewHeight(BuildContext context, int index){
    _commentViewsHeights[index] = (context.findRenderObject() as RenderBox).size.height;
  }


  double _heightOfCommentViewsToIndex(int index){
    double sum = 0;
    for (var i = 0; i < index; i++){
      sum += _commentViewsHeights[i];
    }
    return sum;
  }

  void triggerLogCommentViewHeight(BuildContext context, int index){
    WidgetsBinding.instance.addPostFrameCallback((_) => _logCommentViewHeight(context, index));
  }


  void goToComment(int index){
    if(index == null) return;
    double y = _heightOfCommentViewsToIndex(index);
    _nestedController.animateTo(y, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void _nestedScrollToBottom() {
    _nestedController.animateTo(_nestedController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
  
  ScrollController nestedController() => _nestedController;

  ScrollController outerController() => _outerController;

  void triggerNestedScrollBottom() {

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _nestedScrollToBottom());
  }

}