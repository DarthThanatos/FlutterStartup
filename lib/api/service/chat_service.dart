import 'package:chopper/chopper.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
part 'chat_service.chopper.dart';

@ChopperApi(baseUrl: "/chat")
abstract class ChatService extends ChopperService {

    static ChatService create([ChopperClient client]) => _$ChatService(client);

    @Post()
    Future<Response<BuiltChat>> createChat();

    @Post()
    Future<Response<BuiltChatItem>> postChatItem(@Body() BuiltChatItem item);

    @Post(path: "/like")
    Future<Response<BuiltChatItem>> likeComment(@Body() BuiltChatItem item);

    @Post(path: "/report")
    Future<Response<BuiltChatItem>> reportComment(@Body() BuiltChatItem item);

    @Get()
    Future<Response<BuiltList<BuiltChat>>> getAllChats();

    @Get(path: "/{chatId}")
    Future<Response<BuiltChat>> getChat(@Path("chatId") int chatId);

    @Get(path: "int")
    Future<Response<int>> getTestInt();

    @Get(path: "int-list")
    Future<Response<BuiltList<int>>> getTestIntList();

}