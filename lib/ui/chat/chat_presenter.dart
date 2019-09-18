import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_app/api/model/built_chat.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';
import 'package:flutter_app/api/model/built_file_info.dart';
import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/api/service/file_service.dart';

import 'package:built_collection/built_collection.dart';
import 'contract.dart';

class ChatPresenterImpl implements ChatPresenter{

  static ChatView view;

  final ChatService chatService;
  final FileService fileService;

  ChatPresenterImpl(this.chatService, this.fileService);

  @override
  void downloadAllChats() {
    // TODO: implement downloadAllChats
    return null;
  }

  @override
  void attachView(ChatView incomingView) {
    view = incomingView;
  }

  @override
  void detachView() {
    view = null;
  }

  static BuiltChat _chat;

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

  @override
  void sendMessage(Set<String> filePaths, String text, int parentComment) async {
    if(text == "" && filePaths.length == 0) return;
    _uploadFiles(filePaths)
        .then((s)=> s.map((e)=>e.body).toList())
        .then((l) => _onFilesProcessed(l, text, parentComment));
  }

  void _onFilesProcessed(List<BuiltFileInfo> infos, String text, int parentComment){
    BuiltChatItem item = BuiltChatItem(
        (BuiltChatItemBuilder builder) {
          builder.chatId = _chat.chatId;
          builder.parentId = parentComment;
          builder.text = text;
          builder.creationTime = DateTime.now().toString();
          print("infos: $infos");
          builder.fileInfos = ListBuilder()..addAll(infos);
          return builder.build();
        }
    );
    print("Sending item: $item");
    chatService.postChatItem(item).then(
        (res){
          print("Got response: ${res.body}");
          downloadChat(_chat.chatId);
        }
    );
  }

  Future<List<Response<BuiltFileInfo>>> _uploadFiles(Set<String> filePaths) async {
    return Stream.fromFutures(
        filePaths.map(
            (p) =>
              p.startsWith("http")
                ? fileService.postFileUrl(p)
                : fileService.postFile(p)
        )
    ).toList();
  }

}