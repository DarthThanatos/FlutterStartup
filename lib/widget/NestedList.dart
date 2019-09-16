import 'package:flutter/material.dart';

class NestedList extends StatelessWidget{

  final Widget body;
  final ScrollController controller;

  NestedList({Key key, @required this.body, this.controller}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: controller,
      body: body,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)
        => [
          SliverList(
            delegate:
              SliverChildBuilderDelegate(
                (BuildContext context, int index) => Container(),
                childCount: 0
              ),

          )
        ],

    );

  }



}