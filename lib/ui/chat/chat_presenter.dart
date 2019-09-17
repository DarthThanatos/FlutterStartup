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

  BuiltChat _chat;

  @override
  void downloadChat(int chatId) {
    chatService.getChat(666).then(
      (res){
        _chat = res.body;
        view.displayChat(res.body);
      }
    );
  }

  @override
  BuiltList<BuiltChatItem> flattenChats(BuiltChat chat) {
    return _flattenChatsRec(chat.chatRoot.children);
  }

  BuiltList<BuiltChatItem> _flattenChatsRec(BuiltList<BuiltChatItem> currentChats){
    if (currentChats == null) return BuiltList.from([]);
    final res = [];
    res.addAll(currentChats);
    final flattenChildren = currentChats.map((child) => _flattenChatsRec(child.children));
    flattenChildren.forEach((childList) => res.addAll(childList));
    return BuiltList.from(res);
  }

  @override
  BuiltChatItem getRelatedOrNull(BuiltChatItem commentItem) {
    if(commentItem.parentId == null) return null;
    BuiltChatItem parent =
      _chat.comments.firstWhere(
        (elem) => commentItem.parentId == elem.chatItemId,
        orElse: () => null
      );
    return parent;
  }

  @override
  int idToIndex(int id) {
    final cs = _chat.comments;
    for(var i = 0; i < cs.length; i++){
      if(id == cs[i].chatItemId) return i;
    }
    return null;
  }


}