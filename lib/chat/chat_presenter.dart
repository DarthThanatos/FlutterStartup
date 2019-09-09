import 'package:built_collection/src/list.dart';

import 'package:flutter_app/api/model/built_chat.dart';

import 'contract.dart';

class ChatPresenterImpl implements ChatPresenter{

  ChatView view;

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

}