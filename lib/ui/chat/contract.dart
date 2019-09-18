import 'package:flutter_app/api/model/built_chat.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';

abstract class ChatView {
  void displayAllChats(BuiltList<BuiltChat> chats);
  void displayChat(BuiltChat chat);
}

abstract class ChatPresenter {
  void attachView(ChatView view);
  void detachView();
  void downloadAllChats();
  void downloadChat(int chatId);
  BuiltChatItem getRelatedOrNull(BuiltChatItem commentItem);
  int idToIndex(int id);
  void sendMessage(Set<String> filePaths, String text, int parentComment);

}