import 'package:chopper/chopper.dart';
import 'package:flutter_app/api/chopper_provider.dart';
import 'package:flutter_app/api/converter/built_value_converter.dart';
import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/api/service/file_service.dart';
import 'package:inject/inject.dart';


@module
class ChopperModule{

  final String baseUrl = "http://192.168.0.100:8080";

  @provide
  BuiltValueConverter converter() => BuiltValueConverter();

  @provide
  ChatService chatService(ChopperClient client) => ChatService.create(client);

  @provide
  FileService fileService(ChopperClient client) => FileService.create(client);

  @provide
  ChopperClient chopperClient(BuiltValueConverter converter) =>
      ChopperClient(
        baseUrl: baseUrl,
        converter: converter
    );
}