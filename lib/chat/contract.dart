import 'package:flutter_app/api/model/built_chat.dart';
import 'package:built_collection/built_collection.dart';

abstract class ChatView {
  void displayAllChats(BuiltList<BuiltChat> chats);
}

abstract class ChatPresenter {
  void attachView(ChatView view);
  void detachView();
  void downloadAllChats();
}