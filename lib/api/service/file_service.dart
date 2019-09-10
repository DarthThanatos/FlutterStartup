import 'dart:typed_data';

import 'package:chopper/chopper.dart';
part 'file_service.chopper.dart';

@ChopperApi(baseUrl: "/files")
abstract class FileService extends ChopperService{

  static FileService create([ChopperClient client]) => _$FileService(client);

  @Post(path: "/new")
  @multipart
  Future<Response> postFile(@PartFile("file") String filePath);

  @Get(path: "/{filename}")
  Future<Response<Uint8List>> getFile(@Path("filename") String fileName); // the response will contain the char array of the file body

}