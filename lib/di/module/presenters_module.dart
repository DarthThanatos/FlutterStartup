import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/ui/chat/chat_presenter.dart';
import 'package:flutter_app/ui/chat/contract.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer_contract.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer_presenter.dart';
import 'package:inject/inject.dart';

@module
class PresentersModule{

  @provide
  ChatPresenter chatPresenter(ChatService chatService)
    => ChatPresenterImpl(chatService);

  @provide
  FileViewerPresenter fileViewerPresenter(ChatService chatService)
    => FileViewerPresenterImpl(chatService);

}