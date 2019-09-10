import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/chat/chat_presenter.dart';
import 'package:flutter_app/chat/contract.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer_contract.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer_presenter.dart';
import 'package:inject/inject.dart';

@module
class PresentersModule{

  @provide
  ChatPresenter chatPresenter() => ChatPresenterImpl();

  @provide
  FileViewerPresenter fileViewerPresenter(ChatService chatService)
    => FileViewerPresenterImpl(chatService);

}