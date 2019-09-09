import 'package:chopper/chopper.dart';
import 'package:flutter_app/api/chopper_provider.dart';
import 'package:flutter_app/api/converter/built_value_converter.dart';
import 'package:flutter_app/api/service/chat_service.dart';
import 'package:inject/inject.dart';


// if changed, run the following in the console:
// flutter packages pub run build_runner build/watch

@module
class ChopperModule{

  final String baseUrl = "http://192.168.0.73:8080";

  @provide
  BuiltValueConverter converter() => BuiltValueConverter();

  @provide
  ChatService chatService(ChopperClient client) => ChatService.create(client);

  @provide
  ChopperClient chopperClient(BuiltValueConverter converter) =>
      ChopperClient(
        baseUrl: baseUrl,
        services: [
          ChatService.create()
        ],
        converter: converter
    );
}