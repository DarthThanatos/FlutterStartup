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

  static ChatView _view;
  static BuiltChat _chat;
  static Set<String> _inputPhotosPaths = Set();
  static BuiltChatItem _inputRelatedComment;
  static String _messageText = "";
  
  final ChatService chatService;
  final FileService fileService;

  ChatPresenterImpl(this.chatService, this.fileService){
    print("init presenter");
  }

  @override
  void attachView(ChatView incomingView) {
    _view = incomingView;
  }

  @override
  void detachView() {
    _view = null;
  }

  @override
  void downloadChat(int chatId) {
    chatService.getChat(666).then(
      (res){
        _chat = res.body;
        _view.displayChat(res.body);
      }
    );
  }

  @override
  BuiltChatItem getRelatedOf(BuiltChatItem commentItem) {
    assert (commentItem.parentId != null);
    BuiltChatItem parent =
      _chat.comments.firstWhere(
        (elem) => commentItem.parentId == elem.chatItemId
      );
    return parent;
  }

  @override
  void sendMessage() async {
    if(_messageText == "" && _inputPhotosPaths.length == 0 && _inputRelatedComment == null) return;
    int relatedCommentId = _inputRelatedComment?.chatItemId ?? null;
    _view.showSendingProgressBar();
    _uploadFiles(_inputPhotosPaths)
        .then((s)=> s.map((e)=>e.body).toList())
        .then((l) => _onFilesProcessed(l, _messageText, relatedCommentId));
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

  void _onFilesProcessed(List<BuiltFileInfo> infos, String text, int parentComment){
    BuiltChatItem item = BuiltChatItem(
        (BuiltChatItemBuilder builder) {
          builder.chatId = _chat.chatId;
          builder.parentId = parentComment;
          builder.text = text;
          builder.amountOfLikes = 0;
          builder.likedByMe = false;
          builder.reportedByMe = false;
          builder.creationTime = DateTime.now().toString();
          builder.fileInfos = ListBuilder()..addAll(infos);
          return builder.build();
        }
    );
    chatService.postChatItem(item).then(
        (res){
          _cleanInput();
          _view.hideSendingProgressBar();
          downloadChat(_chat.chatId);
        }
    );
  }

  void _cleanInput(){
    _inputRelatedComment = null;
    _inputPhotosPaths = Set();
    _messageText = "";
  }

  @override
  void addImage(String path) {
    _inputPhotosPaths.add(path);
    _view.onImagesChanged();
  }

  @override
  void removeImage(String path) {
    _inputPhotosPaths.remove(path);
    _view.onImagesChanged();
  }

  @override
  void setMessageText(String text) {
    _messageText = text;
  }

  @override
  String getMessageText() => _messageText;
  
  @override
  void setInputRelatedComment(BuiltChatItem chatItem) {
    _inputRelatedComment = chatItem;
    _view.onRelatedCommentChanged();
  }

  @override
  BuiltChatItem getInputRelatedComment() => _inputRelatedComment;

  @override
  Set<String> getImages() => _inputPhotosPaths;

  @override
  void goToComment(BuiltChatItem comment) {
    int index = _idToIndex(comment.chatItemId);
    _view.onGotoComment(index);
  }

  int _idToIndex(int id) {
    final cs = _chat.comments;
    for(var i = 0; i < cs.length; i++){
      if(id == cs[i].chatItemId) return i;
    }
    return null;
  }

  void _replaceCommentListItem(BuiltChatItem modifiedItem){
    int index = _idToIndex(modifiedItem.chatItemId);
    _chat = _chat.rebuild((BuiltChatBuilder chatBuilder){
      final listBuilder = _chat.comments.toBuilder();
      listBuilder[index] = modifiedItem;
      chatBuilder.comments = listBuilder;
      return chatBuilder.build();
    });
  }

  void _replaceRootComment(BuiltChatItem modifiedItem){
    _chat = _chat.rebuild((BuiltChatBuilder chatBuilder){
      chatBuilder.chatRoot = modifiedItem.toBuilder();
      return chatBuilder.build();
    });
  }

  void _replaceChatItem(BuiltChatItem modifiedItem){
    if(modifiedItem.chatItemId == _chat.chatRoot.chatItemId)
      _replaceRootComment(modifiedItem);
    else
      _replaceCommentListItem(modifiedItem);
  }

  @override
  void likeComment(BuiltChatItem item) => _modifySingleComment(item, chatService.likeComment);

  @override
  void reportComment(BuiltChatItem item) => _modifySingleComment(item, chatService.reportComment);

  void _modifySingleComment(BuiltChatItem item, Future<Response<BuiltChatItem>> Function(BuiltChatItem) modifyFun) {
    modifyFun(item).then((result){
      _replaceChatItem(result.body);
      _view.displayChat(_chat);
    });
  }

  @override
  Set<String> fileInfosToPathsOf(BuiltChatItem chatItem) =>
      chatItem.fileInfos.map((fileInfo) => fileInfo.url).toSet();

}