import 'package:flutter_app/api/service/chat_service.dart';
import 'package:flutter_app/api/service/file_service.dart';
import 'package:flutter_app/chat/chat_page.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer.dart';
import 'package:flutter_app/ui/file_viewer/file_viewer_contract.dart';
import 'package:inject/inject.dart';

@module
class WidgetModule{

  @provide
  ChatPage chatPage(ChatService chatService) => ChatPage(chatService);

  @provide
  FileViewer fileViewer(FileViewerPresenter presenter) => FileViewer(presenter);

  @provide
  FilePickerDemo filePickerDemo(FileService fileService) => FilePickerDemo(fileService);
}