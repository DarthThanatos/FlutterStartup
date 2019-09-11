import 'package:built_collection/src/list.dart';

import 'package:flutter_app/api/model/built_chat.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/api/service/chat_service.dart';

import 'contract.dart';

class ChatPresenterImpl implements ChatPresenter{

  ChatView view;

  final ChatService chatService;

  ChatPresenterImpl(this.chatService);

  @override
  void downloadAllChats() {
    // TODO: implement downloadAllChats
    return null;
  }

  @override
  void attachView(ChatView view) {
    this.view = view;
  }

  @override
  void detachView() {
    view = null;
  }

  @override
  void downloadChat(int chatId) {
    chatService.getChat(666).then(
      (res){view.displayChat(res.body);}
    );
  }

  @override
  BuiltList<BuiltChatItem> flattenChats(BuiltChat chat) {
    return _flattenChatsRec(chat.chatRoot.children);
  }

  BuiltList<BuiltChatItem> _flattenChatsRec(BuiltList<BuiltChatItem> currentChats){
    if (currentChats == null) return BuiltList.from([]);
    final res = [];
    res.addAll(_flattenChatsRec(currentChats));
    return BuiltList.from(res);
  }


}