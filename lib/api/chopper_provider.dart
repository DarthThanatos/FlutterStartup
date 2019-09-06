import 'package:chopper/chopper.dart';
import 'package:flutter_app/api/converter/built_value_converter.dart';
import 'package:flutter_app/api/service/chat_service.dart';

// if changed, run the following in the console:
// flutter packages pub run build_runner build/watch

class ChopperProvider{

  final String rootApi;

  ChopperProvider({this.rootApi});

  static ChopperClient createChopper(String baseUrl) =>
    ChopperClient(
      baseUrl: baseUrl,
      services: [
        ChatService.create()
      ],
      converter: BuiltValueConverter()
  );

}