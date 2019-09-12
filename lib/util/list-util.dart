import 'package:flutter/material.dart';

class ListUtil{

  static List<Widget> mergedList(List<Widget> origin, List<Widget> newItems){
    origin.addAll(newItems);
    return origin;

  }

}