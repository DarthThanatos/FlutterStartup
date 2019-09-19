import 'package:flutter_app/api/model/built_chat.dart';
import 'package:flutter_app/api/model/built_chat_item.dart';

abstract class ChatView {

  void displayChat(BuiltChat chat);
  void onImagesChanged();
  void onRelatedCommentChanged();
  void onGotoComment(int index);
  void showSendingProgressBar();
  void hideSendingProgressBar();

}

abstract class ChatPresenter {

  void attachView(ChatView view);
  void detachView();

  void downloadChat(int chatId);
  void sendMessage();

  void addImage(String path);
  void removeImage(String path);
  Set<String> getImages();

  void setInputRelatedComment(BuiltChatItem chatItem);
  BuiltChatItem getInputRelatedComment();
  BuiltChatItem getRelatedOf(BuiltChatItem commentItem);

  void setMessageText(String text);
  String getMessageText();

  void likeComment(BuiltChatItem item);
  void reportComment(BuiltChatItem item);

  void goToComment(BuiltChatItem comment);
  Set<String> fileInfosToPathsOf(BuiltChatItem chatItem);
}