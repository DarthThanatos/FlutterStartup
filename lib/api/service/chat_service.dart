import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_app/api/model/built_chat.dart';
part 'chat_service.chopper.dart';

@ChopperApi(baseUrl: "/chat")
abstract class ChatService extends ChopperService{

    static ChatService create([ChopperClient client]) => _$ChatService(client);

    @Post()
    Future<Response<BuiltChat>> createChat();

    @Get()
    Future<Response<BuiltList<BuiltChat>>> getAllChats();

    @Get(path: "int")
    Future<Response<int>> getTestInt();

    @Get(path: "int-list")
    Future<Response<BuiltList<int>>> getTestIntList();

}