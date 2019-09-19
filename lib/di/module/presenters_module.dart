import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/api/service/file_service.dart';
import 'package:flutter_app/ui/chat/chat_presenter.dart';
import 'package:flutter_app/ui/chat/contract.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer_contract.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer_presenter.dart';
import 'package:inject/inject.dart';

@module
class PresentersModule{

  @provide @singleton
  ChatPresenter chatPresenter(ChatService chatService, FileService fileService)
    => ChatPresenterImpl(chatService, fileService);

  @provide @singleton
  FileViewerPresenter fileViewerPresenter(ChatService chatService)
    => FileViewerPresenterImpl(chatService);

}