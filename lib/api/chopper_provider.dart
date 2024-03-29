import 'package:chopper/chopper.dart';
import 'package:flutter_app/api/converter/built_value_converter.dart';
import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/api/service/file_service.dart';

class ChopperProvider{

  final String rootApi;

  ChopperProvider({this.rootApi});

  static ChopperClient createChopper(String baseUrl) =>
    ChopperClient(
      baseUrl: baseUrl,
      converter: BuiltValueConverter()
  );

}