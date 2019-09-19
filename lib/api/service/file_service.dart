import 'dart:typed_data';

import 'package:chopper/chopper.dart';
import 'package:flutter_app/api/model/built_file_info.dart';
part 'file_service.chopper.dart';

@ChopperApi(baseUrl: "/files")
abstract class FileService extends ChopperService{

  static FileService create([ChopperClient client]) => _$FileService(client);

  @Post(path: "/new")
  @multipart
  Future<Response<BuiltFileInfo>> postFile(@PartFile("file") String filePath);

  @Post(path: "/new/url")
  Future<Response<BuiltFileInfo>> postFileUrl(@Body() String url);

  @Get(path: "/{filename}")
  Future<Response<Uint8List>> getFile(@Path("filename") String fileName); // the response will contain the char array of the file body

}