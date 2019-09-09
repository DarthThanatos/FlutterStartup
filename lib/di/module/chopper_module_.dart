//import 'package:chopper/chopper.dart';
//import "package:dependencies/dependencies.dart";
//import 'package:flutter_app/api/chopper_provider.dart';
//import 'package:flutter_app/api/service/chat_service.dart';
//
//class ChopperModule implements Module{
//  @override
//  void configure(Binder binder) {
//    final chopper = ChopperProvider
//        .createChopper("http://192.168.0.73:8080");
//    binder.bindSingleton<ChatService>(chopper.getService<ChatService>());
//    binder.bindSingleton<ChopperClient>(chopper);
//  }
//
//}