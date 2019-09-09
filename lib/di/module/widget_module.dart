import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/chat/chat_page.dart';
import 'package:inject/inject.dart';

@module
class WidgetModule{

  @provide
  ChatPage chatPage(ChatService chatService) => ChatPage(chatService);

}